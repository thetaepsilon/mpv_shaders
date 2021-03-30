//!HOOK MAINPRESUB
//!DESC integer upscaling pass with custom pixel response function
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in}.w 4 *
//!HEIGHT ${in}.h 4 *
#define HPIXSZ 4
#define VPIXSZ 4

vec3 response_of(vec3 color, int flag) {
	// we're sort of HDR limiting a max value of 2 here.
	// the limited value is a smoothed curve that soft limits to 1.0.
	// the remainder then compensates for this by lighting up nearby pixels.
	vec3 limited = (2 * color) - (color * color);
	//vec3 remainder = (2 * color) - limited;
	// aka, by algebra...
	vec3 remainder = color * color;
	// however, there are 3x as many overflow pixels, so...
	vec3 sidelight = remainder / 3.;

	vec3 ret = vec3(0.);
	if (flag == 1) {
		ret = sidelight;
	} else if (flag == 2) {
		ret = limited;
	}
	return ret;
}

#define R1 0, 1, 0, 0
#define R2 1, 2, 1, 0
#define FLAG_DATA R1, R2, R2, R1

// export end






#define TEXF ${in}_tex
#define SZ ${in}_size
const vec2 scale = vec2(1./HPIXSZ, 1./VPIXSZ);

const int flag_data[HPIXSZ * VPIXSZ] = int[](
	FLAG_DATA
);

vec2 downscale_vec2(vec2 pix) {
	vec2 _i = pix * scale;
	return vec2(floor(_i.x), floor(_i.y)) + vec2(0.5);
}
vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;
	vec2 srcpix = downscale_vec2(inpix);
	vec2 pos = srcpix / SZ;
	vec3 data = TEXF(pos).rgb;

//#optreplace data = pow(clamp(data, 0., 1.), vec3(${gamma}));

	int idx = (int(mod(inpix.y, VPIXSZ)) * HPIXSZ) + int(mod(inpix.x, HPIXSZ));
	int flag = flag_data[idx];
	data = response_of(data, flag);

//#optreplace data = pow(data, vec3(1./${gamma}));

	return vec4(data, 1.);
}

