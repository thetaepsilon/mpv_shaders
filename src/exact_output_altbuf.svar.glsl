//!HOOK POSTKERNEL
//!DESC pixel exact display pass (no scaling), custom input source
//!BIND ${in}
#define TEXF ${in}_tex
#define SZ ${in}_size
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
//#optreplace data.rgb *= vec3(${lexp});
	return data;
}
