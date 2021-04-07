//!HOOK ${at:MAINPRESUB}
//!DESC gamma workspace prepare pass
//!BIND HOOKED
//!COMPONENTS 3

vec3 f(vec3 c) {
	c = max(c, vec3(0.));
	return pow(c, vec3(${gamma}));
}

vec4 hook() {
	vec3 c = HOOKED_tex(HOOKED_pos).rgb;
	c = f(c);
	return vec4(c, 1.);
}

//!HOOK ${out:POSTKERNEL}
//!DESC pixel exact display pass with gamma correction
//!BIND PREKERNEL
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
	data.rgb = max(data.rgb, vec3(0.));
	data.rgb = pow(data.rgb, vec3(1.) / vec3(${gamma}));
	return data;
}
