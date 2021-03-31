//!WIDTH HOOKED.w 3 *
//!HEIGHT HOOKED.h 3 *
#define HPIXSZ 3
#define VPIXSZ 3


#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
const float T = float(${side_drift:0.333333333});
#define ROW(Y)	vec2(-T, Y),	vec2(0., Y),	vec2(T, Y)
const vec2 drift_lut[3*3] = vec2[](
	ROW(0.),
	ROW(0.),
	ROW(0.5)
);
#undef ROW



#define USE_MODULATION_LUT 1
const float D1 = float(${d1:0.4});
const float DR = float(${dr:D1});
const float DC = float(${dc:D1 * DR});
#define ROW(v)	vec3(v*D1), vec3(v), vec3(v*D1)
const vec3 modulate_lut[3*3] = vec3[](
	ROW(1.),
	ROW(1.),
	vec3(DC), vec3(DR), vec3(DC)
);
#undef ROW

