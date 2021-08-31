//!WIDTH ${in}.w 3 *
//!HEIGHT ${in}.h 3 *
#define HPIXSZ 3
#define VPIXSZ 3

#define USE_MODULATION_LUT 1
#define RED	vec3(1., 0., 0.)
#define GREEN	vec3(0., 1., 0.)
#define BLUE	vec3(0., 0., 1.)
const vec3 modulate_lut[] = vec3[](
	RED,	GREEN,	BLUE,
	GREEN,	BLUE,	RED,
	BLUE,	RED,	GREEN
);
#undef RED
#undef GREEN
#undef BLUE

