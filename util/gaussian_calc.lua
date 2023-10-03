#!/usr/bin/env lua5.1

local usage = [[

Usage: gaussian_calc iter_count data1 data2 data3 [data4 ...]
	calculates a 1D gaussian approximation by repeatedly applying a
	(potentially uneven) box filter kernel to an initial point of value 1.0.
	the kernel's weight values are specified by data1 .. dataN,
	and are normalised to a 1.0 average before application.
	iter_count defines the number of repeated applications.
	the kernel must be comprised of an odd number of data points
	(to have a center point) and be at least 3 values to form a useful kernel.
]]





-- need a tonumber() mode that strictly returns ints, no floats, infs or nans...
-- guess I'll just make one then.
local map = {}
for i = 0, 9, 1 do
	map[tostring(i)] = i
end
local function tonat_base10_iter(str, idx, accum, errmsg)
	if idx >= #str then return accum, idx end

	-- accum starts at zero (see below function) so this is fine for first step.
	accum = accum * 10
	-- called with an initial value of zero later...
	idx = idx + 1
	local char = str:sub(idx, idx)
	local digit = map[char]
	if not digit then
		return nil, errmsg or "invalid character in natural number"
	end

	accum = accum + digit
	return tonat_base10_iter(str, idx, accum, errmsg)
end

local tonat_base10 = function(str, errmsg)
	local accum, len_or_error = tonat_base10_iter(str, 0, 0, errmsg)
	if not accum then
		return nil, len_or_error
	end

	if len_or_error < 1 then
		return nil, errmsg or "empty string passed for natural number"
	end
	assert(len_or_error == #str)
	return accum
end





-- now for handling the kernel values.
-- fracts and negatives (unusual, but whatever) are fine here,
-- but tonumber() also lets the user input (-)inf and (-)nan, so catch those.
local inf = 1 / 0
local function toreal(s)
	local n = tonumber(s)
	if not n then return nil end

	-- NaNs never compare equal even to themselves.
	if n ~= n then return nil end

	if ((n == inf) or (n == -inf)) then return nil end

	return n
end





local modf = math.modf

local baditer = "invalid argument for iter_count: value must be >= 1 and integer."
local badv = ": invalid argument: value must be a valid, non-infinite real number.\n"
local toofew = "kernel needs an odd number of data points and at least three."
local function getargs(_iter_count_s, ...)
	if _iter_count_s == nil then
		error(usage)
	end
	local iter_count =  assert(tonat_base10(_iter_count_s), baditer)
	assert(iter_count > 0, baditer)

	local _kargs = { ... }
	local count = select("#", ...)
	assert(count >= 3, toofew)
	local r, fract = modf((count - 1) * 0.5)
	assert(fract == 0, toofew)

	local raw = {}
	for i = 1, count, 1 do
		local v = toreal(_kargs[i])
		if not v then
			error("\nkernel data value " .. i .. badv)
		end
		raw[i] = v
	end

	return iter_count, raw, count, r
end





-- to avoid increasing or decreasing power on e.g. a 1.0 white image,
-- the totals of the kernel values must sum to one.
-- sort that out here by summing total and dividing all values by that.
-- the exception is if the sum to zero (in which case we'd have a divide by zero),
-- so we have to block that case.
local normalize = function(raw, size)
	local total = 0
	for i = 1, size, 1 do
		total = total + raw[i]
	end

	assert(total ~= 0, "normalisation failed: kernel weights sum to zero!")
	local scaler = 1 / total

	local normalized = {}
	for i = 1, size, 1 do
		normalized[i] = raw[i] * scaler
		--normalized[i] = raw[i]
	end
	normalized.size = size
	return normalized
end





-- create the 1D "image" that will get run through the kernel:
-- mostly 0's with a single 1.0 in the centre.
local init_single_point = function(r, iter_count)
	-- debug mode: add one to iter_count to check edge cases (ha ha)
	--iter_count = iter_count + 1

	-- the kernel "reaches out" r squares when applied,
	-- so to get an accurate output we need at least r * iterations either side.
	local image_radius = r * iter_count
	local image_size = (image_radius * 2) + 1

	local image = {}
	local centre = image_radius + 1
	for i = 1, image_size, 1 do
		image[i] = (i == centre) and 1.0 or 0.0
	end

	image.size = image_size
	return image
end





local apply_kernel = function(image, kernel)
	local result = {}
	local sz = image.size
	local c = kernel.centre

	for i = 1, sz, 1 do
		local result_pixel = 0

		for k = 1, kernel.size, 1 do
			-- kernel data is a regular array,
			-- but we want to work relative to the current image pixel.
			local offset = k - c
			local src = i + offset

			-- return zeroes when the kernel goes off the edge of the image.
			local outofbounds = (src <= 0) or (src > sz)
			local iv = outofbounds and 0.0 or image[src]
			local v = iv * kernel[k]
			result_pixel = result_pixel + v
		end

		result[i] = result_pixel
	end

	result.size = sz
	return result
end





local find_max = function(image)
	local max = 0
	for i = 1, image.size, 1 do
		local v = image[i]
		if v > max then
			max = v
		end
	end
	return max
end









local ceil = math.ceil
local floor = math.floor
local min = math.min
--local blockchars = "▁▂▃▄▅▆▇█"

-- must be careful here, lua strings work in _bytes_ but we're manipulating multibyte chars.
local blockchars = { "▂", "▄", "▆", "█" }
local miniscale = #blockchars

local monospace_plot = function(image, height, trim)
	local sz = image.size

	local max = find_max(image)
	if max <= 0 then
		error("all image values are either negative or zero!")
	end

	-- rescale the values so the maximum value is scaled to the value of height.
	-- then, whenever the current "row" of plotting is less than the value's height,
	-- emit a character in that position, else emit a space.
	-- thus forming a crude bar chart.
	local scaler = (1 / max) * height
	local scaled = {}

	-- XXX: I really need to define a transform for this.
	for i = 1, sz, 1 do
		scaled[i] = image[i] * scaler
	end

	print()
	for h = height, 0, -1 do
		local line = ""

		for i = 1 + trim, sz - trim, 1 do
			local v = scaled[i]
			local blockheight = v - h
			--print(blockheight)
			local pick = floor(blockheight * miniscale)
			local n = min(pick, miniscale)
			local char = (pick <= 0) and " " or blockchars[n]
			line = line .. char
		end

		print(line)
	end
end







local list_to_set = function(list)
	local set = {}
	for i, v in ipairs(list) do
		set[v] = true
	end
	return set
end






-- env vars used for optional plotting later but is validated up front.
local env = os.getenv
local getenv_nat_optional = function(name)
	local var = env(name)
	if var then
		local v, err = tonat_base10(var)
		if not v then
			error(
				"invalid, negative or non-integer value in optional var "
				.. name .. ": " .. err)
		end
		return v
	else
		return nil
	end
end

-- XXX: there's _reaaaaally_ a bunch of stuff I should shove in a library here...
local yeslist = {
	"yes",
	"true",
	"1",
}
local nolist = {
	"no",
	"false",
	"0",
	""
}
local yesset = list_to_set(yeslist)
local noset = list_to_set(nolist)

local getenv_bool_optional = function(name, default)
	local var = env(name)
	if var then
		if yesset[var] then
			return true
		elseif noset[var] then
			return false
		else
			error("invalid boolean value in optional env var " .. name)
		end
	else
		return default
	end
end

local height = getenv_nat_optional("plot_height")
local trim = getenv_nat_optional("plot_trim") or 0
local precision = getenv_nat_optional("format_precision") or 15
--assert(precision > 0, "format_precision needs to be >0 to get useful output.")

local no_normalise = getenv_bool_optional("no_normalise", false)


local iter_count, raw, size, r = getargs(...)
local kernel
if no_normalise then
	kernel = raw
	kernel.size = size
else
	kernel = normalize(raw, size)
end
kernel.radius = r
kernel.centre = r + 1

local _verbose = os.getenv("verbose")
local function verbose(...)
	if _verbose then
		print(...)
	end
end

verbose("# input kernel values:", unpack(raw, 1, size))
verbose("# kernel data after normalisation (summing to 1.0):", unpack(kernel, 1, kernel.size))
verbose("# iteration count:", iter_count)

local image = init_single_point(r, iter_count)
for i = 1, iter_count, 1 do
	image = apply_kernel(image, kernel)
end


--print(unpack(image, 1, image.size))


local fmt = "%."..tostring(precision).."f"

if height then
	print("# plot (height " .. height .. ", REQUIRES UTF-8):")
	monospace_plot(image, height, trim)
else
	verbose("# resulting data:")
	for i = 1, image.size, 1 do
		print(fmt:format(image[i]))
	end
	verbose("# end data")
end




