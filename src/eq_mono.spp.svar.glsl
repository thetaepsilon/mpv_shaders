//!HOOK ${after:MAINPRESUB}
//!DESC EQ effect shader (turns pixels on and off in brightness sequence)
//!BIND ${in}
//!SAVE ${out:$in}
//#include lutdata

// ^ expects: const float multiplier, const float lut[],
// const (float-like) HPIXSZ, const (float-like) VPIXSZ.
// lut is encoded in row-major order, with x1, y1 ... xn, y1 coming first.
// this is going _downwards_ in Y (i.e. source code writing order),
// as mpv arranges for Y to be down even in GLSL shaders.

const vec2 scale = vec2(1 / float(HPIXSZ), 1 / float(VPIXSZ));

vec2 nearest(vec2 pix) {
	return vec2(floor(pix.x), floor(pix.y)) + vec2(0.5);
}

const float gamma = ${gamma:1.};
const float gi = 1. / gamma;

const float sz = (HPIXSZ) * (VPIXSZ);

vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;
	vec2 nearest_src_pix = nearest(inpix * scale);

	int which_x = int(mod(inpix.x, float(HPIXSZ)));
	int which_y = int(mod(inpix.y, float(VPIXSZ)));
	int idx = (which_y * HPIXSZ) + which_x;

	vec2 pos = nearest_src_pix / ${in}_size;
	vec4 data = ${in}_tex( pos );
	vec3 d = clamp(data.rgb, 0., 1.);
	d = pow(d, vec3(gamma));
	vec3 total = d * multiplier;
	float base = lut[idx];
	vec3 rebased = total - vec3(base);
	vec3 result = clamp(rebased, 0., 1.);
	result = pow(result, vec3(gi));

	data.rgb = result;

	// debug section stuff, leave this alone
	//data.r = float(idx) / sz;

	return data;
}
