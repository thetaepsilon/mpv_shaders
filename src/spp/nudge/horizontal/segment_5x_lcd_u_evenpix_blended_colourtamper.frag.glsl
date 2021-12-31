//!WIDTH ${in}.w 5 *
//!HEIGHT ${in}.h 1 *
#define HPIXSZ 5
#define VPIXSZ 1


#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
#define V(x) vec2(x, 0.)
const float N1 = 0.25;
const float N2 = 0.5;
const float NT = 1. / 16.;
const vec2 drift_lut[5] = vec2[](
	V(-N2),
	V(-N1),
	V(-NT),
	V(NT),
	V(N1)
);


#define USE_MODULATION_LUT 1
#define CUSTOM_MODULATE 1
#define MODULATE_DISABLE_CLAMP 1

const float D1 = 1. / 512.;
//const float D2 = D1 * D1;
const vec3 tint[5*1] = vec3[](
	vec3(D1), // midpoint

	vec3(D1),
	
	vec3(1., 1., 1.),
	vec3(1., 1., 1.),
	
	vec3(D1)
);

const bool _enable[5*1] = bool[](
	true, true, false, false, true
);


vec3 modulate_hook(vec3 v, int idx) {
	vec3 post = tint[idx];
	bool enable = _enable[idx];


	float b = min(min(v.r, v.g), v.b);
	vec3 base = vec3(b);
	vec3 chopped = v - base;

	vec3 processed = mix(chopped, v, 1./8.);

	v = enable ? processed : v;

	v *= post;

	return v;
}
