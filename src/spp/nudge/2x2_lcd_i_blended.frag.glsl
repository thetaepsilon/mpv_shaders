//!WIDTH HOOKED.w 2 *
//!HEIGHT HOOKED.h 2 *
#define HPIXSZ 2
#define VPIXSZ 2


#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
#define ROW(Y)	vec2(0, Y), vec2(0.5, Y)
const vec2 drift_lut[2*2] = vec2[](
	ROW(0),
	ROW(0.)
);
#undef ROW
#undef T



#define USE_MODULATION_LUT 1
#define ROW(v) vec3(v), vec3(0.125*v)
const vec3 modulate_lut[2*2] = vec3[](
	ROW(1.00),
	ROW(0.75)
);

