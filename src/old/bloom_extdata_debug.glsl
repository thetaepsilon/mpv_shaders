//!HOOK MAINPRESUB
//!BIND HOOKED
//!BIND blurdata
//!DESC bloom using additive box blur ("blur data not included!"), debug
vec4 hook() {
	vec4 addend = blurdata_tex(HOOKED_pos) * 1.;
	return addend;
}



