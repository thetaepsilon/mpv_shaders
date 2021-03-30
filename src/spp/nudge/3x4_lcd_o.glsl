//!WIDTH HOOKED.w 3 *
//!HEIGHT HOOKED.h 4 *
#define HPIXSZ 3
#define VPIXSZ 4



#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
#define ROW(v) vec2(-0.333, v), vec2(0., v), vec2(0.333, v)

vec2 drift_lut[] = vec2[](
        ROW(0),
        ROW(0),
        ROW(0),
        ROW(0.5)
);
#undef ROW




#define USE_MODULATION_LUT 1
const float d1 = ${dim:0.125};
#define R(v) vec3(v * d1), vec3(v), vec3(v * d1)
const vec3 modulate_lut[] = vec3[](
	R(1),
	R(1),
	R(1),
	R(d1)
);
#undef R

