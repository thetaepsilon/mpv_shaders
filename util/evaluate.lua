#!/usr/bin/env lua5.1

local usage = [[
Usage: evaluate.lua start stop step expr
generic expression evaluator.
expr must take the form of a valid lua expression of x, e.g. "math.sin(x) / x".
start, stop and step are the usual numeric arguments to a lua range for loop.
optional env vars:
format: overrides the default used for string.format of result values.
]]

assert(select("#", ...) == 4, usage)

local _start, _stop, _step, expr = ...

local function n(s, name)
	local v = tonumber(s)
	if not v then
		error("argument number conversion failed for " .. name)
	end
	return v
end

local start = n(_start, "start")
local stop = n(_stop, "stop")
local step = n(_step, "step")

local compile = "return function(x) return ( " .. expr .. " ) end"
local chunk = assert(loadstring(compile))
local f = chunk()

-- buffer the results and don't write them immediately for now.
-- this prevents partial dud data escaping if there's a problem.
-- could always add a "streaming" mode later on if needed.
local buf = {}
local l = 0
for x = start, stop, step do
	l = l + 1
	buf[l] = f(x)
end

local fmt = os.getenv("format") or "%.12f"

local formatted = {}
for i = 1, l, 1 do
	formatted[i] = fmt:format(buf[i])
end

for i = 1, l, 1 do
	print(formatted[i])
end
