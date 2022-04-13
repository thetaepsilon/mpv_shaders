#!/usr/bin/env lua5.3

-- crude pascal's triangle generator.
-- the binomial numbers one can get out of each row are useful for finite gaussian approximations.

local _count = ...
local count = assert(tonumber(_count))

local lastrow = { 1 }
local get = function(idx)
	local v = lastrow[idx]
	return v or 0
end

for size = 1, count, 1 do
	local newrow = {}

	for i = 1, size, 1 do
		local elem = get(i-1) + get(i)
		newrow[i] = elem
	end

	print(table.unpack(newrow))
	lastrow = newrow
end

