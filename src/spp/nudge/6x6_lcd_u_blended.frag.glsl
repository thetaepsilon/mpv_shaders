//!WIDTH HOOKED.w 6 *
//!HEIGHT HOOKED.h 6 *
#define HPIXSZ 6
#define VPIXSZ 6



#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
#define N1 0.25
#define ROW(v) \
        vec2(-N1, v), \
        vec2(0, v), vec2(0, v), vec2(0, v), \
        vec2( N1, v), \
        vec2(0.5, v)

vec2 drift_lut[] = vec2[](
        ROW(0),
        ROW(0),
        ROW(0),
        ROW(0),
        ROW(0),
        ROW(0.5)
);
#undef ROW



#define USE_MODULATION_LUT 1
#define D 0.375
#define D2 0.15625
#define D3 0.500
#define D4 0.250
#define ROW(v)  vec3(v*D3), vec3(v), vec3(v), vec3(v), vec3(v*D3), vec3(v*D4)
const vec3 modulate_lut[6*6] = vec3[](
        ROW(1),
        ROW(1),
        ROW(1),
        ROW(1),
        ROW(1),
        ROW(0.5)
);
#undef ROW
