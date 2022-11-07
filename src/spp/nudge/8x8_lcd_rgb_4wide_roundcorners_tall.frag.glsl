//!WIDTH ${in}.w 8 *
//!HEIGHT ${in}.h 8 *
#define HPIXSZ 8
#define VPIXSZ 8


#define MAINROW \
	vec3(0., 0., 0.), \
	vec3(1., 0., 0.), \
	vec3(1., 1., 0.), \
	vec3(1., 1., 1.), \
	vec3(1., 1., 1.), \
	vec3(0., 1., 1.), \
	vec3(0., 0., 1.), \
	vec3(0., 0., 0.)

#define ENDROW \
	vec3(0., 0., 0.), \
	vec3(0., 0., 0.), \
	vec3(1., 0., 0.), \
	vec3(1., 1., 0.), \
	vec3(0., 1., 1.), \
	vec3(0., 0., 1.), \
	vec3(0., 0., 0.), \
	vec3(0., 0., 0.)

const vec3 Z = vec3(0.);
#define ZR Z, Z, Z, Z, Z, Z, Z, Z

#define USE_MODULATION_LUT 1
const vec3 modulate_lut[8*8] = vec3[](
	ZR,
	ENDROW,
	MAINROW,
	MAINROW,
	MAINROW,
	MAINROW,
	MAINROW,
	ENDROW
);

