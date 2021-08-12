//!HOOK ${at:MAINPRESUB}
//!DESC integer upscaling pass with configurable nudge and colourize LUTs
//!BIND ${in}
//!SAVE ${out:$in}
//#include lutdata



const vec2 scale = vec2(1./float(HPIXSZ), 1./float(VPIXSZ));

vec2 nearest(vec2 pix) {
	return vec2(floor(pix.x), floor(pix.y)) + vec2(0.5);
}



// util functions for transform_expr and edgedetect to possibly use.
float sum(vec3 v) {
	return (v.r + v.g + v.b);
}
float avg(vec3 v) {
	return sum(v) * 0.33333;
};
float hmax(vec3 v) {
	return max(v.r, max(v.g, v.b));
};



//#include? edgedetect



vec3 input_gamma(vec3 data) {
	data = max(data, vec3(0.));
//#optreplace data = pow(data, vec3(${input_gamma}));
	return data;
}



vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;
//#optreplace if (${jitter_expr}) inpix += vec2(1.);
	vec2 downscaled = inpix * scale;
	vec2 nearest_pix = nearest(downscaled);

	int which_x = int(mod(inpix.x, float(HPIXSZ)));
	int which_y = int(mod(inpix.y, float(VPIXSZ)));
	#if ${swap_axes:0}
	int idx = (which_x * HPIXSZ) + which_y;
	#else
	int idx = (which_y * HPIXSZ) + which_x;
	#endif

	vec2 srcpix = nearest_pix;
	#ifdef USE_DRIFT_LUT
	vec2 drift_data = drift_lut[idx];

	#if ${swap_axes:0}
	drift_data = drift_data.yx;
	#endif

	#ifdef DRIFT_LUT_IS_ABS
	vec2 drift = drift_data;
	#else

	// we have the original linear position (downscaled)
	// and the nearest center of pixel (nearest_pix).
	// we then scale the difference a very small amount towards the linear position,
	// such that we get a position that mixes a trace amount of the neighbouring pixel in.
	vec2 drift_multiplier = drift_data;
	vec2 unity_drift = downscaled - nearest_pix;
	vec2 drift = (unity_drift * drift_multiplier);

	#endif
	srcpix += drift;
	#endif

	vec2 pos = srcpix / ${in}_size;
	vec3 data = ${in}_tex(pos).rgb;
	data = input_gamma(data);



	// optional edge detection ish mode:
	// the original location is sampled,
	// and a function is given both the original and the lerped pixel value.
	// for this to work the "edgedetect" optional spp include above must be loaded,
	// and it must define USE_EDGEDETECT_FUNCTION as well as the below named function.
	#ifdef USE_EDGEDETECT_FUNCTION
	vec3 origin_data = ${in}_tex(nearest_pix / ${in}_size).rgb;
	origin_data = input_gamma(origin_data);
	vec3 edgedetected = edgedetect(origin_data, data);
	data = bool(${edgedetect_ab_expr:true}) ? edgedetected : data;
	#endif



	#ifdef USE_MODULATION_LUT
	vec3 mixer = modulate_lut[idx];

	// svar debug may override what is meant by darkening the pixel
	// (sometimes a simple multiply doesn't look right).
	// in that case base colour and the usual mix procedures probably don't make sense.
	#if ${alt_func_mode:0}

	vec3 c = data;
	vec3 m = mixer;
	data = (${alt_func_expr:alt_func_expr_not_defined()});

	// not alt_func_mode
	#else

	#ifndef MODULATE_BASE_COLOR
	#define MODULATE_BASE_COLOR ${basecol:0, 0, 0}
	#endif
	const vec3 base = vec3(MODULATE_BASE_COLOR);
	data = mix(base, data, mixer);

	// endif alt_func_mode
	#endif

	#endif


//#optreplace vec3 c = data; data = (${transform_expr});

//#optreplace data = pow(data, vec3(1.) / vec3(${output_gamma}));
	return vec4(data, 1.);
}

