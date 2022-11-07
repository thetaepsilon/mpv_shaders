//!WIDTH ${in}.w 8 *
//!HEIGHT ${in}.h 1 *
#define HPIXSZ 8
#define VPIXSZ 1




#define USE_MODULATION_LUT 1
const vec3 modulate_lut[8] = vec3[](
	vec3(0., 0., 0.),
	vec3(1., 0., 0.),
	vec3(1., 1., 0.),
	vec3(1., 1., 1.),
	vec3(1., 1., 1.),
	vec3(0., 1., 1.),
	vec3(0., 0., 1.),
	vec3(0., 0., 0.)
);

