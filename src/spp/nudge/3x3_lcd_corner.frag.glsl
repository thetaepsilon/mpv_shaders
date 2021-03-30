//!WIDTH HOOKED.w 3 *
//!HEIGHT HOOKED.h 3 *
#define HPIXSZ 3
#define VPIXSZ 3

#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
#define ROW(v) vec2(0, v), vec2(0, v), vec2(0.5, v)
const vec2 drift_lut[] = vec2[](
	ROW(0),
	ROW(0),
	ROW(0.125)
);
#undef ROW

#define USE_MODULATION_LUT 1
#define ROW(v)	vec3(v), vec3(v), vec3(0.375)
const vec3 modulate_lut[3*3] = vec3[](
	ROW(1),
	ROW(1),
	ROW(0.75)
);
#undef ROW

