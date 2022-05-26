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
#define W vec3(1.)
const vec3 modulate_lut[] = vec3[](
	vec3(0.),
	vec3(0.33),
	vec3(1.0),
	vec3(1.0),
	vec3(0.33)
);


