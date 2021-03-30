//!WIDTH HOOKED.w 4 *
//!HEIGHT HOOKED.h 4 *
#define HPIXSZ 4
#define VPIXSZ 4


#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1

#define T 0.375
#define T2 0.125
#define Z vec2(0)
#define ROW(Y)	vec2(-T, Y),	Z,	Z,	vec2(T, Y)
#define Y1 0.5
const vec2 drift_lut[4*4] = vec2[](
	ROW(-0.25),
	ROW(0),
	ROW(0.25),
	vec2(-T, Y1),	vec2(-T2, Y1),	vec2(T2, Y1),	vec2(T, Y1)
);
#undef ROW

#define USE_MODULATION_LUT 1
#define D1 (7. / 16.)
#define ROW(v)	vec3(D1 * v), vec3(v), vec3(v), vec3(D1 * v)
const vec3 modulate_lut[4*4] = vec3[](
	ROW(1),
	ROW(1),
	ROW(1),
	vec3(D1), vec3(D1), vec3(D1), vec3(D1)
);
#undef ROW



#undef Z
