//!HOOK ${after:POSTKERNEL}
//!DESC display video centered or cropped at non-resizeable stage
//!BIND HOOKED
//!BIND ${in}


const float interval = float(${blankdraw_interval:10});

bool shouldblank() {
	return ${blank_condition:(int(mod(float(frame), interval)) == 0)};
}

vec4 blank() {
	if (shouldblank()) {
		return vec4(${blank_colour:0.});
	} else {
		discard;
	}
}



vec4 hook() {
	ivec2 draw_coordinates = ivec2(gl_FragCoord.xy);
	ivec2 draw_size = ivec2(HOOKED_size);

	ivec2 input_size = ivec2(${in}_size);

	ivec2 padding = (draw_size - input_size) / 2;

	ivec2 input_coordinates = draw_coordinates - padding;

	bvec2 oob_negative = lessThan(input_coordinates, ivec2(0));
	bvec2 oob_positive = greaterThanEqual(input_coordinates, input_size);
	bool outofbounds = any(oob_negative) || any(oob_positive);

	if (outofbounds) {
		return blank();
	}

	vec2 coords_f = vec2(input_coordinates) + vec2(0.5);
	vec2 pos = coords_f / ${in}_size;
	return ${in}_tex(pos);
}


