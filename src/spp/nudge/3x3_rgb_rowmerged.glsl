//!WIDTH ${in}.w 3 *
//!HEIGHT ${in}.h 3 *
#define HPIXSZ 3
#define VPIXSZ 3

#define USE_MODULATION_LUT 1
#define R(v) \
	v * vec3(	1.,	0.,	0.), \
	v * vec3(	0.,	1.,	0.), \
	v * vec3(	0.,	0.,	1.)
#define Z vec3(0.)
const vec3 modulate_lut[] = vec3[](
	R(1.0),
	R(1.0),
	R(0.25)
);



#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
#define Y(v) vec2(0.0, v)
#define ROW(v) Y(v), Y(v), Y(v)
const vec2 drift_lut[3*3] = vec2[](
	ROW(0.),
	ROW(0.),
	ROW(0.5)
);

