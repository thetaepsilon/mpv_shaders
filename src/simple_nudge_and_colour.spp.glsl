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
	vec2 drift_data = drift_lut[idx];

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

//#optreplace #if ${input_transform_clamp:1}	// ${input_transform}
//#optreplace data = max(data, vec3(0.));	// ${input_transform}
//#optreplace #endif				// ${input_transform}
//#optreplace data = vec3(${input_transform});



	#ifndef MODULATE_DISABLE_CLAMP
	data = max(data, vec3(0.));
	#endif	// MODULATE_DISABLE_CLAMP

	#ifdef USE_MODULATION_LUT
	#ifndef CUSTOM_MODULATE
	vec3 mixer = modulate_lut[idx];

	#ifndef MODULATE_BASE_COLOR
	#define MODULATE_BASE_COLOR ${basecol:0, 0, 0}
	#endif
	const vec3 base = vec3(MODULATE_BASE_COLOR);
	data = mix(base, data, mixer);

	#else	// CUSTOM_MODULATE


	data = modulate_hook(data, idx);


	#endif	// CUSTOM_MODULATE

	#endif



//#optreplace vec3 c = data; data = (${transform_expr});

	return vec4(data, 1.);
}

