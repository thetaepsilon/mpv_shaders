//!WIDTH ${in}.w 1 *
//!HEIGHT ${in}.h 5 *
#define HPIXSZ 1
#define VPIXSZ 5



#define USE_MODULATION_LUT 1
#define W vec3(1.)
const vec3 modulate_lut[] = vec3[](
	vec3(0.),
	W,
	W,
	W,
	vec3(0.)
);
#undef W

