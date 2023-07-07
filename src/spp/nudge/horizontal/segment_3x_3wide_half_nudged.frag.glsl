//!WIDTH ${in}.w 3 *
//!HEIGHT ${in}.h 1 *
#define HPIXSZ 3
#define VPIXSZ 1



#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
const vec2 drift_lut[3] = vec2[](
	vec2(0.),
	vec2(0.),
	vec2(0.5, 0.)
);

