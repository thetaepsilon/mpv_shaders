//!HOOK MAINPRESUB
//!DESC recombine luminosity and chromadata
//!BIND HOOKED
//!BIND luminosity
//!BIND chromadata
vec4 hook() {
	vec2 p = HOOKED_pos;
	vec3 data = chromadata_tex(p).rgb;
	float lum = luminosity_tex(p).r;
	data *= lum;
	/*
	#define CLAMP(c) data.c = min( data.c , 1.0)
	CLAMP(r);
	CLAMP(g);
	CLAMP(b);
	#undef CLAMP
	*/
	return vec4(data, 1.);
}
