//!WIDTH ${in}.w 5 *
//!HEIGHT ${in}.h 5 *
#define HPIXSZ 5
#define VPIXSZ 5



#define USE_MODULATION_LUT 1
#define Z vec3(0.)
#define ROW \
	vec3(1.0, 0.0, 0.0), \
	vec3(1.0, 1.0, 0.0), \
	vec3(1.0, 1.0, 1.0), \
	vec3(0.0, 1.0, 1.0), \
	vec3(0.0, 0.0, 1.0)

const vec3 modulate_lut[5*5] = vec3[](
	ROW,
	ROW,
	ROW,
	ROW,
	Z, Z, Z, Z, Z
);

#undef ROW
#undef Z

