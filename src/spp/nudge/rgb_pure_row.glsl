//!WIDTH ${in}.w 3 *
//!HEIGHT ${in}.h
#define HPIXSZ 3
#define VPIXSZ 1

#define USE_MODULATION_LUT 1

const vec3 modulate_lut[] = vec3[](
	vec3(	1.,	0.,	0.),
	vec3(	0.,	1.,	0.),
	vec3(	0.,	0.,	1.)
);

