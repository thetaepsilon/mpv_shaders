//!HOOK ${after:MAINPRESUB}
//!DESC downsampling pass: nearest neighbour (multiplier config)
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH HOOKED.w ${x} /
//!HEIGHT HOOKED.h ${y:$x} /

#define SX ${x}
#define SY ${y:$x}

#define TEXF ${in} ## _tex
#define SZ (${in} ## _size)

vec2 offset = vec2(float(${ox:0}), float(${oy:0}));

vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;
	float tx = floor(inpix.x * float(SX));
	float ty = floor(inpix.y * float(SY));

	vec2 pix = vec2(tx + 0.5, ty + 0.5) + offset;

	vec2 pt = pix / SZ;
	return TEXF(pt);
}

