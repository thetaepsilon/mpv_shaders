//!WIDTH ${in}.w 1 *
//!HEIGHT ${in}.h 4 *
#define HPIXSZ 1
#define VPIXSZ 4


#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
#define Z vec2(0.)
vec2 drift_lut[] = vec2[](
	Z,
	Z,
	Z,
	vec2(0., 0.5)
);
#undef Z

#define USE_MODULATION_LUT 1
#define W vec3(1.)
const vec3 modulate_lut[] = vec3[](
	W,
	W,
	W,
	vec3(0)
);
#undef W

