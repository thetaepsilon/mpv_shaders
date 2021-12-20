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

#define ROW vec3(2.0), vec3(1.0), vec3(2.0)
#define R2 3.0
#define TABLE(X) \
	const vec3 X [3*3] = vec3[]( \
		ROW, \
		ROW, \
		vec3(R2), vec3(R2), vec3(R2)\
	);

TABLE(_pow)
#undef R2
#undef ROW

#define ROW vec3(0.125), vec3(1.0), vec3(0.125)
#define R2 0.125
TABLE(_mult)
#undef ROW
#undef R2

#define ROW vec3(0.), vec3(1.), vec3(0.)
#define R2 0.
TABLE(_mask)
#undef ROW
#undef R2



// FIXME: not actually perceptual
const vec3 percep_weight = vec3(0.3, 0.4, 0.3);

vec3 modulate_hook(vec3 data, int i) {
	vec3 p = _pow[i];
	vec3 m = _mult[i];

	float maxi = max(data.r, max(data.g, data.b));
	float percep = dot(data, percep_weight);
	float scale = maxi / percep;
	scale = mix(1.0, scale, 0.5);
	scale *= scale;

	vec3 e = pow(data * m, p) * scale;
	return mix(e, data, _mask[i]);
}
#undef ROW

