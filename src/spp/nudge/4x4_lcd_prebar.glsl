//!WIDTH ${in}.w 4 *
//!HEIGHT ${in}.h 4 *
#define HPIXSZ 4
#define VPIXSZ 4



#define USE_MODULATION_LUT 1
#define Z vec3(0.)
#define ROW \
	vec3(0.0), \
	vec3(0.5), \
	vec3(1.0), \
	vec3(0.5)

const vec3 modulate_lut[4*4] = vec3[](
	ROW,
	ROW,
	ROW,
	Z, Z, Z, Z
);

#undef ROW
#undef Z

