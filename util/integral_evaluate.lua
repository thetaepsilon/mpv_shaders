#!/usr/bin/env lua5.1

local usage = [[
Usage: evaluate.lua start stop step expr
integral exact area evaluator.
expr must take the form of a valid lua expression of x, e.g. "math.sin(x) / x".
start, stop and step are the usual numeric arguments to a lua range for loop,
however they are inclusive bounds which is important for the below calculation.

each loop iteration, the area between the last position and the current one
(so there needs to be at least two to be useful)
is calculated by invoking f(x_last) and f(x),
then subtracting the former from the latter to calculate the integral between these limits.

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

assert(start <= stop, "iterations must be strictly increasing to work correctly.")

local compile = "return function(x) return ( " .. expr .. " ) end"
local chunk = assert(loadstring(compile))
local f = chunk()

-- buffer the results and don't write them immediately for now.
-- this prevents partial dud data escaping if there's a problem.
-- could always add a "streaming" mode later on if needed.
local buf = {}
local l = 0
local r_prev = nil

local _x = start
while _x <= stop do
	local x = _x
	local r = f(x)

	if r_prev then
		local area = r - r_prev
		buf[l] = area
	end

	r_prev = r

	-- increment delayed to the end intentionally.
	-- on the second iteration (the first we have two values)
	-- we want to write to the first array position.
	l = l + 1
	_x = _x + step
end
local s = l - 1

local fmt = os.getenv("format") or "%.12f"

local formatted = {}
for i = 1, s, 1 do
	formatted[i] = fmt:format(buf[i])
end

for i = 1, s, 1 do
	print(formatted[i])
end
