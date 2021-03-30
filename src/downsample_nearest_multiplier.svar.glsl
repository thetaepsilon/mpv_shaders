//!HOOK MAINPRESUB
//!DESC downsampling pass: nearest neighbour (multiplier config)
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH HOOKED.w ${x} /
//!HEIGHT HOOKED.h ${y:$x} /

#define SX ${x}
#define SY ${y:$x}

#define TEXF ${in} ## _tex
#define SZ (${in} ## _size)

// TODO: update svar to allow optional variables?
// would allow setting these optionally but have them default to zero.
vec2 offset = vec2(0, 0);

vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;
	float tx = floor(inpix.x * SX);
	float ty = floor(inpix.y * SY);

	vec2 pix = vec2(tx + 0.5, ty + 0.5) + offset;

	vec2 pt = pix / SZ;
	return TEXF(pt);
}

