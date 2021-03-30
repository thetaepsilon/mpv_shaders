//!WIDTH HOOKED.w 4 *
//!HEIGHT HOOKED.h 4 *
#define HPIXSZ 4
#define VPIXSZ 4


#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1


#define T 0.3333333333333
#define Z vec2(0.)
#define ROW(Y)	vec2(-T, Y),	vec2(0., Y),	vec2(0., Y),	vec2(T, Y)
const vec2 drift_lut[4*4] = vec2[](
	ROW(0.),
	ROW(0.),
	ROW(0.),
	ROW(0.5)
);
#undef ROW

#define USE_MODULATION_LUT 1
#define D1 ${d1:(9. / 16.)}
#define ROW(v)	vec3(D1 * v), vec3(v), vec3(v), vec3(D1 * v)
const vec3 modulate_lut[4*4] = vec3[](
	ROW(1.),
	ROW(1.),
	ROW(1.),
	ROW(0.5)
);
#undef ROW



#undef Z
