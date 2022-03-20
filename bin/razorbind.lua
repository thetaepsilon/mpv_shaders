#!/usr/bin/env lua5.3

local usage = [[

Usage: razorbind.lua streammode scriptfile.lua [script args] < docfile

Processes docfile with @{var} and @!var style substitutions.
scriptfile is evaluated, being passed script args in it's varargs (...) array,
which must then return a table T whose keys will be used as described,
or a function lookup(keyname) whose return values will be used in a similar fashion.

streammode controls the write-out mode for transformed lines of docfile.
streammode = buffered buffers all lines before saving,
so partial files aren't written on error if being used in a pipeline.
streammode = stream prints lines as they are processed.

variable names must be composed of lowercase ascii letters, ascii digits,
and underscores, with a minimum length 1. in other words, [a-z0-9_]+ .

@{varname} anywhere on a line gets replaced by calling lookup("varname")
(or T["varname"] for tables), which must return a singular string.

@!varname may only occur once per line, may only be proceeded by whitespace,
and must otherwise be the sole contents of a line.
here lookup("varname") or T["varname"] must yield a list-like table of strings,
which will be copied one per line into the output.
any proceeding whitespace (e.g. indentation) will be prepended to each copied line.

in any case, lookups that return nil, or that yield the incorrect type,
will cause an error.

all returned data may be cached.
returned functions and tables from the script must be pure (including metatables).

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
	"script returned unsupported lookup table type: expected function or table, got "

local setup_getter = function(obj, label)
	local ret = nil
	local t = type(obj)

	if t == "table" then
		ret = function(k)
			return obj[k]
		end
	elseif t == "function" then
		ret = obj
	else
		error(err_type .. t .. " for " .. label)
	end

	return ret
end


local parse_stream_mode = function(mode)
	local stream = false
	if mode then
		if mode == "stream" then
			stream = true
		elseif mode ~= "buffered" then
			error("unrecognised value for streammode: " .. mode)
		end
	end
	return stream
end

local use_args = function(_streammode, scriptpath, ...)
	local streammode = parse_stream_mode(_streammode)

	--assert(docpath, usage)
	assert(scriptpath, usage)

	local script = assert(loadfile(scriptpath))
	local _lookup, _multiline = script(...)

	local lookup = setup_getter(_lookup, "lookup")

	--local docfile = assert(io.open(docpath))
	return streammode, lookup
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



local process_doc = function(getline, _lookup, writeln)
	local lookup 	= cache_(_lookup, validate_lookup)
	local multiline	= cache_(_lookup, validate_multiline)

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



local main = function(_print, ...)
	local stream, lookup = use_args(...)
	local docfile = io.stdin

	local writeln, flush = setup_output_stream(_print, stream)

	process_doc(docfile:lines(), lookup, writeln)
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

os.exit(protected_main(print, ...))

