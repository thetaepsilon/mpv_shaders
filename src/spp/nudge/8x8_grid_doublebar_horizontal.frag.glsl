//!WIDTH ${in}.w 8 *
//!HEIGHT ${in}.h 8 *
#define HPIXSZ 8
#define VPIXSZ 8



#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
#define ROW(v) \
	vec2(-0.5, v), \
	vec2(-0.25, v), \
	vec2(0, v), vec2(0, v), vec2(0, v), vec2(0, v), vec2(0, v), \
	vec2(0.25, v)

vec2 drift_lut[] = vec2[](
	ROW(0),
	ROW(0),
	ROW(0),
	ROW(0),
	ROW(0),
	ROW(0),
	ROW(0),
	ROW(0.5)
);
#undef ROW



#define USE_MODULATION_LUT 1
#define D 0.25
#define ROW(v) \
	vec3(v*0.875), \
	vec3(v*D), \
	vec3(v), vec3(v), vec3(v), vec3(v), vec3(v), \
	vec3(v*D)

#define V1 0.9375
const vec3 modulate_lut[8*8] = vec3[](
	ROW(V1),
	ROW(1),
	ROW(1),
	ROW(1),
	ROW(1),
	ROW(1),
	ROW(V1),
	ROW(0)
);
#undef ROW
