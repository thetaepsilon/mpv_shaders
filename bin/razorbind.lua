#!/usr/bin/env lua5.3

local usage = [[

Usage: razorbind.lua scriptfile.lua [script args] < docfile

Processes docfile with @{var} and @!var style substitutions.
scriptfile is evaluated, being passed script args in it's varargs (...) array,
which must then return two instances of a table, function, or nil.
(called respectively "lookup" and "multiline" below).
nil will cause lookups of the respective kinds below to raise an error.

variable names must be composed of lowercase ascii letters, ascii digits,
and underscores, with a minimum length 1. in other words, [a-z0-9_]+ .

@{varname} anywhere on a line gets replaced by calling lookup("varname")
(or [] for tables), returning a string.

@!varname may only occur once per line, may only be proceeded by whitespace,
and must otherwise be the sole contents of a line.
here multiline("varname") is called and must return a list-like table of strings,
which will be substituted one per line into the output.

all returned data may be cached.
returned functions and tables from the script must be pure (including metatables).

optional arguments in env vars:
* mode ( = stream, buffered )
	write-out mode for transformed lines of docfile.
	default (mode = buffered) is to buffer all lines before saving,
	so partial files aren't written on error if being used in a pipeline.
	mode = stream prints lines as they are processed.
]]



-- sanity shorthand for partially applied functions used further down.
local f = function(v)
	assert(type(v) == "function")
end

-- wraps explicit error calls in a table so they can be distinguished from semantic bugs
-- (which should continue to result in strings produced by the interpreter itself).
-- see later on in main where return codes are handled.
local _stacktrace = debug.traceback
local _error = error
local error_meta = {
	__tostring = function(e)
		return "input error: " .. e.message .. "\n" .. e.stacktrace
	end
}
error = function(msg)
	--local trace = _stacktrace()
	local e = {
		__synthetic = true,
		message = msg,
		--stacktrace = trace,
	}
	setmetatable(e, error_meta)
	_error(e)
end
local is_synthetic = function(err)
	return (type(err) == "table") and err.__synthetic
end
error_helper = function(e)
	local trace = _stacktrace()
	if not is_synthetic(e) then
		local ret = {
			message = e
		}
		e = ret
	end
	e.stacktrace = trace
	return e
end



local err_type =
	"script returned unsupported lookup table type: expected function, table, or nil, got "

local setup_getter = function(obj, label)
	local ret = nil
	local t = type(obj)

	if t == "table" then
		ret = function(k)
			return obj[k]
		end
	elseif t == "function" then
		ret = obj
	elseif t == "nil" then
		ret = function(k)
			error(
				"doc wanted " .. label .. " variable " .. k ..
				", but the script file did not return an object for " .. label)
		end
	else
		error(err_type .. t .. " for " .. label)
	end

	return ret
end

local use_args = function(scriptpath, ...)
	--assert(docpath, usage)
	assert(scriptpath, usage)

	local script = assert(loadfile(scriptpath))
	local _lookup, _multiline = script(...)

	local lookup = setup_getter(_lookup, "lookup")
	local multiline = setup_getter(_multiline, "multiline")	

	--local docfile = assert(io.open(docpath))
	return lookup, multiline
end

local parse_stream_mode = function(mode)
	local stream = false
	if mode then
		if mode == "stream" then
			stream = true
		elseif mode ~= "buffered" then
			error("unrecognised value for mode variable: " .. mode)
		end
	end
	return stream
end

local setup_output_stream = function(_print, stream)
	local writeln, flush = nil, nil
	if stream then
		writeln = function(s)
			return _print(tostring(s))
		end
		flush = function() end
	else
		local buffer = {}
		local i = 0
		writeln = function(s)
			i = i + 1
			buffer[i] = tostring(s)
		end
		flush = function()
			for _, s in ipairs(buffer) do
				_print(s)
			end
			buffer = nil
		end
	end
	return writeln, flush
end





local validate_lookup = function(v, varname)
	if v == nil then
		error("document error: variable " .. varname .. " doesn't exist.")
	end

	local t = type(v)
	if t ~= "string" then
		error(
			"bound script error for variable " .. varname ..
			": expected string, got " .. t)
	end
	return v
end

local validate_multiline = function(v, varname)
	if v == nil then
		error("document error: multiline variable " .. varname .. " doesn't exist.")
	end

	local t = type(v)
	if t ~= "table" then
		error(
			"bound script error for multiline variable " .. varname ..
			": expected table, got " .. t)
	end
	local list = {}
	for index, item in ipairs(v) do
		local t = type(item)
		if t ~= "string" then
			error(
				"bound script error: multiline variable " ..
				varname .. ": index " .. index ..
				" was not a string.")
		end
		list[index] = item
	end
	return list
end

local cache_ = function(uncached, validate)
	local cache = {}
	f(uncached)
	f(validate)

	return function(key)
		local hit = cache[key]
		if not hit then
			local raw = uncached(key)
			hit = validate(raw)
			cache[key] = hit
		end
		return hit
	end
end







local legal_varname = "^[a-z0-9_]+$"

local try_multiline = function(line, lineno, multiline, writeln)
	local leading, varname = line:match("^([^@]*)@!(.*)$")
	if not varname then return false end

	if not leading:match("^%s*$") then
		error(lineno() .. "non-whitespace garbage preceeding @!")
	end
	if #varname == 0 then
		error(lineno() .. "missing multiline variable name after @!")
	end
	local legal = varname:match(legal_varname)
	if not legal then
		-- XXX: unprintable char filtering in case of user error supplying binary input?
		error(lineno() .. "illegal variable name " .. varname)
	end

	local block = multiline(varname)
	for _, line in ipairs(block) do
		writeln(leading .. line)
	end

	return true
end



local var_replacer_ = function(lineno, lookup)
	f(lineno)
	f(lookup)
	return function(startpos, varname)
		if not varname:match(legal_varname) then
			error(
				lineno() .. "column " .. startpos ..
				": illegal variable name " .. varname)
		end
		local sub = lookup(varname)
		return sub
	end
end

local try_varsub = function(line, lineno, lookup, writeln)
	local replacer = var_replacer_(lineno, lookup)

	local substituted = line:gsub("()@{([^}]*)}", replacer)
	writeln(substituted)
end



local process_doc = function(getline, _lookup, _multiline, writeln)
	local lookup 	= cache_(_lookup, validate_lookup)
	local multiline	= cache_(_multiline, validate_multiline)

	local _lineno = 0
	local lineno = function()
		return "line " .. tostring(_lineno) .. ": "
	end

	for line in getline do
		_lineno = _lineno + 1
		-- as lua's patterns lack alternation we have to do them one by one.
		-- this is eased by the fact that the patterns involved
		-- (namely @{...} and @!...) are unambiguous to each other,
		-- so at least we can safely test them one at a time.
		-- furthermore multiline is different in that only one of it can appear per line,
		-- whereas normal vars may be multiple (or no) occurences per line otherwise.
		if not try_multiline(line, lineno, multiline, writeln) then
			-- note that again as otherwise lines have 0..many var substitutions,
			-- this function is expected to pass through "normal" lines.
			try_varsub(line, lineno, lookup, writeln)
		end
	end
end



local main = function(_print, getenv, ...)
	local lookup, multiline = use_args(...)
	local docfile = io.stdin

	local mode = os.getenv("mode")
	local stream = parse_stream_mode(mode)
	local writeln, flush = setup_output_stream(_print, stream)

	process_doc(docfile:lines(), lookup, multiline, writeln)
	flush()
end

-- somewhat annoyingly we can't catch stack traces from errors thrown by the interpreter usually.
-- we have to employ a combination of xpcall and the error wrapper above.
-- porting this to lua5.1 would require an argless wrapper for main here.
local protected_main = function(...)
	local success, err = xpcall(main, error_helper, ...)
	local ret = 0
	if not success then
		local synthetic = is_synthetic(err)
		ret = synthetic and 2 or 1
		local label = synthetic and "thrown error" or "bug"
		io.stderr:write(
			label .. ": " .. err.message .. "\n" ..
			err.stacktrace .. "\n")
		io.stderr:flush()
	end
	return ret
end

os.exit(protected_main(print, os.getenv, ...))

