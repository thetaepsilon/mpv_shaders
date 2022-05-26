//!WIDTH ${in}.w 1 *
//!HEIGHT ${in}.h 5 *
#define HPIXSZ 1
#define VPIXSZ 5



/*
0
1
1
0
0
*/


#define USE_MODULATION_LUT 1
#define V(x) vec3(x * 4. / 3.)
const vec3 modulate_lut[5] = vec3[](
	V(0.5),
	V(0.75),
	V(0.5),
	V(0.125),
	V(0.125)	// of next pixel
);
#undef V

#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
#define Z vec2(0.)
vec2 drift_lut[5] = vec2[](
	Z,
	Z,
	Z,
	Z,
	vec2(0., 1.0)
);
#undef Z


