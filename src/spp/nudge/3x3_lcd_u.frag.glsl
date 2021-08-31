//!WIDTH ${in}.w 3 *
//!HEIGHT ${in}.h 3 *
#define HPIXSZ 3
#define VPIXSZ 3



#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
#define T 0.333333
#define ROW(Y)	vec2(-T, Y),	vec2(0, Y),	vec2(T, Y)
const vec2 drift_lut[3*3] = vec2[](
	ROW(0),
	ROW(0),
	ROW(0.5)
);
#undef ROW
#undef T




#define USE_MODULATION_LUT 1
#define ROW(v)	vec3(0), vec3(v), vec3(0)
const vec3 modulate_lut[3*3] = vec3[](
	ROW(1),
	ROW(1),
	ROW(0)
);
#undef ROW

