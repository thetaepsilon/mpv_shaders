//!WIDTH ${in}.w 4 *
//!HEIGHT ${in}.h 1 *
#define HPIXSZ 4
#define VPIXSZ 1


#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
#define V(x) vec2(x, 0.)
const float N1 = float(${n1:0.25});
const vec2 drift_lut[4] = vec2[](
	V(-N1),
	V(0.00),
	V(N1),
	V(0.5)
);


#define USE_MODULATION_LUT 1
const float D1 = float(${d1:(9. / 16.)});
const float D2 = float(${d2:D1});
const vec3 modulate_lut[4*1] = vec3[](
	vec3(D1),
	vec3(1.),
	vec3(D1),
	vec3(D2)
);

