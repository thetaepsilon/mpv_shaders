//!HOOK MAINPRESUB
//!DESC RGB average grayscale luminosity
//!BIND HOOKED
//!SAVE luminosity
//!WIDTH HOOKED.w
//!HEIGHT HOOKED.h
//!COMPONENTS 1
vec4 hook() {
	vec4 orig = HOOKED_tex(HOOKED_pos);
	float L = (orig.r + orig.g + orig.b) * 0.333;
	orig.rgb = vec3(L);
	return orig;
}

