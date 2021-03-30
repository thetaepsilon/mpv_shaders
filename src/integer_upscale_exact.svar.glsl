//!HOOK MAINPRESUB
//!DESC integer upscaling pass
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in}.w ${x} *
//!HEIGHT ${in}.h ${y:$x} *
#define TEXF ${in}_tex
#define SZ ${in}_size
const vec2 scale = vec2(1./float(${x}), 1./float(${y:$x}));

vec2 downscale_vec2(vec2 pix) {
	vec2 _i = pix * scale;
	return vec2(floor(_i.x), floor(_i.y)) + vec2(0.5);
}
vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;
	vec2 srcpix = downscale_vec2(inpix);
	vec2 pos = srcpix / SZ;
	return TEXF(pos);
}

