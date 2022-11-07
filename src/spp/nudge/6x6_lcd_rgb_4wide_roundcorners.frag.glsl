//!WIDTH ${in}.w 6 *
//!HEIGHT ${in}.h 6 *
#define HPIXSZ 6
#define VPIXSZ 6


#define MAINROW \
	vec3(1., 0., 0.), \
	vec3(1., 1., 0.), \
	vec3(1., 1., 1.), \
	vec3(1., 1., 1.), \
	vec3(0., 1., 1.), \
	vec3(0., 0., 1.)

#define ENDROW \
	vec3(0., 0., 0.), \
	vec3(1., 0., 0.), \
	vec3(1., 1., 0.), \
	vec3(0., 1., 1.), \
	vec3(0., 0., 1.), \
	vec3(0., 0., 0.)

const vec3 Z = vec3(0.);
#define ZR Z, Z, Z, Z, Z, Z

#define USE_MODULATION_LUT 1
const vec3 modulate_lut[6*6] = vec3[](
	ENDROW,
	MAINROW,
	MAINROW,
	MAINROW,
	ENDROW,
	ZR
);

