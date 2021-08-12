//!WIDTH ${in}.w 3 *
//!HEIGHT ${in}.h 1 *
#define HPIXSZ 3
#define VPIXSZ 1




#define USE_MODULATION_LUT 1
const vec3 modulate_lut[3] = vec3[](
	vec3(0.600,	0.375,		0.100),
	vec3(1.00,	1.0,		1.0),
	vec3(0.150,	0.375,		0.650)
);

