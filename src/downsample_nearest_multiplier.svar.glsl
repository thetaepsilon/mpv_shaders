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

vec2 offset = vec2(${offset:0});

vec4 hook() {
	vec2 inpix = floor(gl_FragCoord.xy);
	vec2 t = inpix * vec2(SX, SY);
	vec2 nearest = floor(t);

	vec2 pix = nearest + vec2(0.5) + offset;

	vec2 pt = pix / SZ;
	vec4 result = TEXF(pt);

//#optreplace result = ${output_transform};
	return result;
}

