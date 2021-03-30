//!HOOK PREKERNEL
//!DESC transformed scaling, prekernel phase
//!BIND HOOKED
//!COMPONENTS 3

//#include map

vec4 hook() {
	vec3 c = HOOKED_tex(HOOKED_pos).rgb;
	#define F(x) (f(c.x))
	return vec4(F(r), F(g), F(b), 1.);
	#undef F
}




//!HOOK POSTKERNEL
//!DESC transformed scaling, postkernel phase
//!BIND HOOKED
//!COMPONENTS 3

//#include unmap

vec4 hook() {
	vec3 c = HOOKED_tex(HOOKED_pos).rgb;
	#define F(x) (f_undo(c.x))
	return vec4(F(r), F(g), F(b), 1.);
	#undef F
}




