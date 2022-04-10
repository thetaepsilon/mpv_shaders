//!WIDTH ${in}.w 2 *
//!HEIGHT ${in}.h 2 *
#define HPIXSZ 2
#define VPIXSZ 2



#define USE_MODULATION_LUT 1
#define Z vec3(0.)
const vec3 modulate_lut[2*2] = vec3[](
	vec3(1., 0., 1.),
	vec3(0., 1., 0.),

	Z, Z
);
#undef Z

