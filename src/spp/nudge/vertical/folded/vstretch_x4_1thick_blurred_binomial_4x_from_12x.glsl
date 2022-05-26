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
67
957
957
67
*/


#define USE_MODULATION_LUT 1
#define V(x) vec3(float(x) / 957.)
const vec3 modulate_lut[4] = vec3[](
	V(67),
	V(957),
	V(957),
	V(67)
);
#undef V




