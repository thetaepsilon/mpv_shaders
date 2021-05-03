//!HOOK MAINPRESUB
//!DESC downsampling pass: total area per-channel maximum
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH HOOKED.w ${x} /
//!HEIGHT HOOKED.h ${y:$x} /

const int loop_x = (${x});
const int loop_y = (${y:$x});

const vec2 scaler = vec2(loop_x, loop_y);

#define TEXF ${in} ## _tex
#define SZ (${in} ## _size)

vec2 offset = vec2(float(${ox:0}), float(${oy:0}));

vec4 hook() {
	vec2 inpix = floor(gl_FragCoord.xy);
	vec2 sample_origin = inpix * scaler;
	vec3 maximum = vec3(0.);

	for (int x = 0; x < loop_x; x++) {
	for (int y = 0; y < loop_y; y++) {
		vec2 srcpix = sample_origin + vec2(float(x), float(y));
		vec2 srcpt = srcpix / SZ;
		vec3 c = TEXF(srcpt).rgb;

		maximum = max(c, maximum);
	}
	}
	return vec4(maximum, 1.0);
}
