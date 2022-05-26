//!WIDTH ${in}.w 1 *
//!HEIGHT ${in}.h 4 *
#define HPIXSZ 1
#define VPIXSZ 4



/*
0
1
0
0
*/

/*
10
120
252
120
10
*/

/*
120
252
120
20	// 10 each from this and next pixel, 0.5 lerp
*/



#define USE_MODULATION_LUT 1
#define V(x) vec3(float(x) / 252.)
const vec3 modulate_lut[4] = vec3[](
	V(120),
	V(252),
	V(120),
	V(20)
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
	vec2(0., 0.5)
);
#undef Z


