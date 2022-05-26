#!/usr/bin/env lua5.1

local usage = [[

Usage: some_stdin_source | compact.lua factor
	reads a list of lua parseable numbers, one per line,
	then does an area map combine of them with a size of factor;
	e.g. if 15 numbers are fed into stdin and a factor of 5 is given,
	then each multiple of 5 is summed and written to stdout one per line.
	yielding 3 output lines.
	useful for compacting 1D gaussian kernels.

	note this tool is most useful with gaussian kernels that are already normalised.
	currently this tool will not renormalise to compensate for floating point errors.

	* optional env vars:
	format:
		printf-style format specifier to be passed to string.format.
		output values will be formatted with this.
		format string should accept a single (potentially floating point) argument.
]]

if select("#", ...) ~= 1 then
	error(usage)
end

local modf = math.modf
local __factor = ...
local _factor = assert(tonumber(__factor), "factor not recogniseable as a number.")
local factor, _f = modf(_factor)
local nat = "only integer factors greater than 1 are supported."
assert(_f == 0, nat)
assert(factor > 1, nat)

-- some initial sanity testing of the format string.
-- can't catch everything but should catch some dumb mistakes up front.
local outfmt = os.getenv("format") or "%0.15f"
outfmt:format(0)





local data = {}
local size = 0
for l in io.stdin:lines() do
	local _s = size + 1
	local v = tonumber(l)
	if not v then
		error("input line " .. _s " not recogniseable as a number.")
	end
	data[_s] = v
	size = _s
end



-- yes, yes, I know, redefinition of _f
local outcount, _f = modf(size / factor)
if _f ~= 0 then
	error("input data size (" .. size .. ") not divisible by factor of " .. factor .. "!")
end
local compacted = {}

for cidx = 1, outcount, 1 do
	-- beware, beware! off by one indexing!
	local base = ((cidx - 1) * factor)
	local total = 0
	for aidx = 1, factor, 1 do
		local idx = base + aidx
		total = total + data[idx]
	end
	compacted[cidx] = total
end

for cidx = 1, outcount, 1 do
	local v = compacted[cidx]
	local formatted = outfmt:format(v)
	print(formatted)
end







