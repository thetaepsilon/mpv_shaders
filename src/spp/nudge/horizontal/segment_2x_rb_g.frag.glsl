//!WIDTH ${in}.w 2 *
//!HEIGHT ${in}.h
#define HPIXSZ 2
#define VPIXSZ 1

#define USE_MODULATION_LUT 1

const vec3 modulate_lut[2] = vec3[](
	vec3(	1.,	0.,	1.),
	vec3(	0.,	1.,	0.)
);

