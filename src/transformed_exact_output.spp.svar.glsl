//!HOOK ${at:MAINPRESUB}
//!DESC transformed space exact output, setup phase
//!BIND HOOKED

//#include funcs

vec4 hook() {
	vec3 c = HOOKED_tex(HOOKED_pos).rgb;
	c = f(c);
	return vec4(c, 1.);
}




//!HOOK POSTKERNEL
//!DESC transformed space exact output, undo draw phase
//!BIND PREKERNEL

//#include funcs

#define TEXF PREKERNEL_tex
#define SZ PREKERNEL_size
vec2 pad = vec2(0, 0);
bool outofbounds(float f) {
	return (f < 0.) || (f > 1.);
}
vec4 hook() {
	vec2 pix = gl_FragCoord.xy - pad;
	vec2 pos = pix / SZ;
	bool nowrite = (outofbounds(pos.x) || outofbounds(pos.y));
	if (nowrite) {
		if (mod(float(frame), 60.) < 1.) {
			return vec4(0.);
		} else {
			discard;
		}
	}
	vec4 data = TEXF(pos);
	
	data.rgb = f_undo(data.rgb);
	return data;
}




