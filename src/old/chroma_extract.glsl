//!HOOK MAINPRESUB
//!DESC extract chroma info based on previously extracted luminosity
//!BIND HOOKED
//!BIND luminosity
//!SAVE chromadata
//!WIDTH HOOKED.w
//!HEIGHT HOOKED.h
#define FVEC3(v) (vec3((F(v.r)), (F(v.g)), (F(v.b))))
vec4 hook() {
	vec2 p = HOOKED_pos;
	vec4 data = HOOKED_tex(p);
	//float lum = max(luminosity_tex(p).r, 0.);
	float lum = luminosity_tex(p).r;
	vec3 chroma = data.rgb / lum;
	bool z = (lum <= 0.);
	chroma = z ? vec3(0.) : chroma;
	#define F(x) ( max( x , 0.) )
	data.rgb = FVEC3(chroma);
	#undef F
	return data;
}
