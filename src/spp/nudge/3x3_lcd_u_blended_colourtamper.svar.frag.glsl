//!WIDTH ${in}.w 3 *
//!HEIGHT ${in}.h 3 *
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
#define CUSTOM_MODULATE 1
#define MODULATE_DISABLE_CLAMP 1

const float D1 = 1. / 128.;
const float D2 = 0.;
const vec3 DR = vec3(D2);
#define ROW vec3(D1), vec3(1.), vec3(D1)
const vec3 tint[3*3] = vec3[](
	ROW,
	ROW,
	DR, DR, DR
);
#undef ROW

const bool _enable[3*3] = bool[](
	true,	false,	true,
	true,	false,	true,
	true,	true,	true
);


vec3 _fp = vec3(1.0, 1.5, 1.0);
vec3 modulate_hook(vec3 v, int idx) {
	vec3 post = tint[idx];
	bool enable = _enable[idx];


	float b = min(min(v.r, v.g), v.b);
	vec3 base = vec3(b);
	vec3 chopped = v - base;

	//vec3 processed = mix(chopped, v, 1./32.);
	vec3 processed = pow(chopped * 0.5, _fp);

	v = enable ? processed : v;

	v *= post;

	return v;
}
