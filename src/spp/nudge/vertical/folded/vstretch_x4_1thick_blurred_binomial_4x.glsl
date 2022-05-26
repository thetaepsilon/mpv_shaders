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


#define USE_MODULATION_LUT 1
#define V(x) vec3(x * 8. / 3.)
const vec3 modulate_lut[4] = vec3[](
	V(0.125),
	V(0.375),
	V(0.375),
	V(0.125)
);
#undef V




