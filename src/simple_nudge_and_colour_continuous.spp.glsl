//!HOOK POSTKERNEL
//!DESC integer upscaling pass with replaceable nudge and color change functions
//!BIND POSTKERNEL
//!BIND ${in:PREKERNEL}

//#include transform_funcs



vec2 scale = ${in}_size / POSTKERNEL_size;

vec2 nearest(vec2 pix) {
	return vec2(floor(pix.x), floor(pix.y)) + vec2(0.5);
}

vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;
	vec2 downscaled = inpix * scale;
	vec2 srcpix = nearest(downscaled);
	vec2 delta = downscaled - srcpix;


	#ifdef USE_DRIFT_TRANSFORM
	vec2 drift = transform_drift(delta);
	srcpix += drift;
	#endif

	vec2 pos = srcpix / ${in}_size;
	vec4 data = ${in}_tex(pos);

	#ifdef USE_COLOR_TRANSFORM
	data.rgb = transform_color(delta, data.rgb);
	#endif

	return data;
}

