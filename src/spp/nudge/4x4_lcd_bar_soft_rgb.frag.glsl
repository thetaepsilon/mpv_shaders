//!WIDTH ${in}.w 4 *
//!HEIGHT ${in}.h 4 *
#define HPIXSZ 4
#define VPIXSZ 4



#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
#define ROW(Y)	vec2(0., Y),	vec2(0., Y),	vec2(0., Y),	vec2(0., Y)
const vec2 drift_lut[4*4] = vec2[](
	ROW(0.0),
	ROW(0.0),
	ROW(0.0),
	ROW(0.5)
);
#undef ROW
#undef T




#define USE_MODULATION_LUT 1
const float dip = float(${chandip:0.33});
#define M(v) (1.0 - (float(v) * dip))
//XXX: display subpixel order hardcoded!
#define RGB(v) (vec3(v) * vec3(M(0), M(1), M(2)))
#define BGR(v) (vec3(v) * vec3(M(2), M(1), M(0)))
#define ROW(v)	vec3(0.0), BGR(v), RGB(v), vec3(0.0)
const float D1 = float(${d1:0.25});
const vec3 modulate_lut[4*4] = vec3[](
	ROW(1.0),
	ROW(1.0),
	ROW(1.0),
	ROW(D1)
);
#undef ROW

