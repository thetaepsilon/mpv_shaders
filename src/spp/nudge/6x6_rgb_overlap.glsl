//!WIDTH HOOKED.w 6 *
//!HEIGHT HOOKED.h 6 *
#define HPIXSZ 6
#define VPIXSZ 6

#define USE_MODULATION_LUT 1
#define W vec3(1.)
#define Z vec3(0.)
#define R \
	vec3(	1.,	0.,	0.), \
	vec3(	1.,	1.,	0.), \
	W, \
	vec3(	0.,	1.,	1.), \
	vec3(	0.,	0.,	1.), \
	Z

const vec3 modulate_lut[] = vec3[](
	Z,
	R,
	R,
	R,
	R,
	Z
);

