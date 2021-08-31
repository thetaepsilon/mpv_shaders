//!WIDTH ${in}.w 5 *
//!HEIGHT ${in}.h 5 *
#define HPIXSZ 5
#define VPIXSZ 5


#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1


#define Z vec2(0.)
#define ROW(Y)	vec2(-0.25, Y),	vec2(0., Y),	vec2(0., Y),	vec2(0.25, Y),	vec2(0.5, Y)
const vec2 drift_lut[5*5] = vec2[](
	ROW(0.),
	ROW(0.),
	ROW(0.),
	ROW(0.),
	ROW(0.5)
);
#undef ROW

#define USE_MODULATION_LUT 1
const float D1 = float(${d1:(9. / 16.)});
const float D2 = float(${d2:D1});
#define ROW(v)	vec3(D1 * v), vec3(v), vec3(v), vec3(D1 * v), vec3(D2 * v)
const vec3 modulate_lut[5*5] = vec3[](
	ROW(1.),
	ROW(1.),
	ROW(1.),
	ROW(1.),
	ROW(0.5)
);
#undef ROW



#undef Z
