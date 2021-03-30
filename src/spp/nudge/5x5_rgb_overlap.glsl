//!WIDTH HOOKED.w 5 *
//!HEIGHT HOOKED.h 5 *
#define HPIXSZ 5
#define VPIXSZ 5

#define USE_MODULATION_LUT 1
#define W vec3(1.)
#define Z vec3(0.)
/*
#define R \
	vec3(	1.,	0.,	0.), \
	vec3(	1.,	1.,	0.), \
	vec3(	0.,	1.,	1.), \
	vec3(	0.,	0.,	1.), \
	Z
*/
#define R \
	vec3(	1.0,	0.5,	0.0	), \
	W, \
	W, \
	vec3(	0.0,	0.5,	1.0	), \
	Z

const vec3 modulate_lut[] = vec3[](
	R,
	R,
	R,
	R,
	Z
);

