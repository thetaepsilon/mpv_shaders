//!HOOK ${at:MAINPRESUB}
//!DESC integer upscaling pass with configurable nudge and colourize LUTs
//!BIND ${in}
//!SAVE ${out:$in}
//#include lutdata



const vec2 scale = vec2(1./float(HPIXSZ), 1./float(VPIXSZ));

vec2 nearest(vec2 pix) {
	return vec2(floor(pix.x), floor(pix.y)) + vec2(0.5);
}





vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;
//#optreplace if (${jitter_expr}) inpix += vec2(1.);
	vec2 downscaled = inpix * scale;
	vec2 nearest_pix = nearest(downscaled);

	int which_x = int(mod(inpix.x, float(HPIXSZ)));
	int which_y = int(mod(inpix.y, float(VPIXSZ)));

	int idx = (which_y * HPIXSZ) + which_x;


	vec2 srcpix = nearest_pix;
	#ifdef USE_DRIFT_LUT
	#if DRIFT_LUT_IS_ABS != 1
	#error "multiplier drift mode is deprecated and removed".
	#endif
	vec2 drift_data = drift_lut[idx];
	vec2 drift = drift_data;

	srcpix += drift;
	#endif

	vec2 pos = srcpix / ${in}_size;
	vec3 data = ${in}_tex(pos).rgb;



	// some old functionality removed for streamlining.
	// activated by some preprocessor defines when they were used
	// (which were set by the lutdata spp section files),
	// so just make them error out instead
	// (the behaviour when they weren't used has been preserved).
	#ifdef CUSTOM_MODULATE
	#error "CUSTOM_MODULATE has been removed."
	#endif
	#ifdef MODULATE_BASE_COLOR
	#error "custom MODULATE_BASE_COLOR has been removed."
	#endif



	#ifdef USE_MODULATION_LUT
	vec3 mixer = modulate_lut[idx];
	data = data * mixer;
	#endif



//#optreplace vec3 c = data; data = (${transform_expr});

	return vec4(data, 1.);
}

