//!WIDTH ${in}.w 4 *
//!HEIGHT ${in}.h 4 *
#define HPIXSZ 4
#define VPIXSZ 4



#define USE_MODULATION_LUT 1
#define M vec3(1., 0., 1.)
#define G vec3(0., 1., 0.)
#define Z vec3(0.)

const vec3 modulate_lut[4*4] = vec3[](
	M, G, M, G,
	G, M, G, M,
	M, G, M, G,
	Z, Z, Z, Z
);

#undef Z
#undef M
#undef G

