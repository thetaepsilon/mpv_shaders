//!WIDTH HOOKED.w 3 *
//!HEIGHT HOOKED.h 3 *
#define HPIXSZ 3
#define VPIXSZ 3

#define USE_MODULATION_LUT 1
#define R \
	vec3(	1.,	0.,	0.), \
	vec3(	0.,	1.,	0.), \
	vec3(	0.,	0.,	1.)
#define Z vec3(0.)
const vec3 modulate_lut[] = vec3[](
	R,
	R,
	Z, Z, Z
);

