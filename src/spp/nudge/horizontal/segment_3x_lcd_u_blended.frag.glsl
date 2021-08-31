//!WIDTH ${in}.w 3 *
//!HEIGHT ${in}.h 1 *
#define HPIXSZ 3
#define VPIXSZ 1


#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
#define V(x) vec2(x, 0.)
const vec2 drift_lut[3] = vec2[](
	V(-0.33333),
	V(0.00),
	V(0.33333)
);


#define USE_MODULATION_LUT 1
const float D1 = float(${d1:(9. / 16.)});
const vec3 modulate_lut[3] = vec3[](
	vec3(D1),
	vec3(1.),
	vec3(D1)
);

