//!HOOK MAINPRESUB
//!DESC RGB max channel luminosity
//!BIND HOOKED
//!SAVE luminosity
//!WIDTH HOOKED.w
//!HEIGHT HOOKED.h
//!COMPONENTS 1
vec4 hook() {
	vec4 orig = HOOKED_tex(HOOKED_pos);
	float L = max(orig.r, max(orig.g, orig.b));
	orig.rgb = vec3(L);
	return orig;
}

