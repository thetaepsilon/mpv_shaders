//!HOOK MAINPRESUB
//!DESC integer upscaling pass with nudge LUTs, RGB separate tables
//!BIND ${in}
//!SAVE ${out:$in}
//#include lutdata

#define TEXF ${in}_tex
#define SZ ${in}_size


const vec2 scale = vec2(1./float(HPIXSZ), 1./float(VPIXSZ));

vec2 nearest(vec2 pix) {
	return vec2(floor(pix.x), floor(pix.y)) + vec2(0.5);
}

vec4 read(vec2 srcpix) {
	vec2 pos = srcpix / SZ;
	vec4 data = TEXF(pos);
	return data;
}

vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;
	vec2 downscaled = inpix * scale;
	vec2 nearest_pix = nearest(downscaled);

	int which_x = int(mod(gl_FragCoord.x, float(HPIXSZ)));
	int which_y = int(mod(gl_FragCoord.y, float(VPIXSZ)));
	int idx = (which_y * HPIXSZ) + which_x;

	#define GET(C) \
		vec2 nudge_ ## C = nudge_lut_ ## C[idx]; \
		vec2 srcpix_ ## C = nearest_pix + nudge_ ## C ; \
		float C = read( srcpix_ ## C ).C

	GET(r);
	GET(g);
	GET(b);
	vec3 data = vec3(r, g, b);

	

	#ifdef USE_MODULATION_LUT
	data = data * modulate_lut[idx];
	#endif
	#ifdef USE_MODULATION_LUT_X
	data *= modulate_lut_x[which_x];
	#endif
	#ifdef USE_MODULATION_LUT_Y
	data *= modulate_lut_y[which_y];
	#endif

	return vec4(data, 1.);
}

