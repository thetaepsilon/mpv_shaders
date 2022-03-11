//!HOOK ${at:MAINPRESUB}
//!DESC transformed scaling, prekernel phase
//!BIND HOOKED

//#include funcs

vec4 hook() {
	vec3 c = HOOKED_tex(HOOKED_pos).rgb;
	c = f(c);
	return vec4(c, 1.);
}




//!HOOK POSTKERNEL
//!DESC transformed scaling, postkernel phase
//!BIND HOOKED

//#include funcs

vec4 hook() {
	vec3 c = HOOKED_tex(HOOKED_pos).rgb;
	c = f_undo(c);
	return vec4(c, 1.);
}




