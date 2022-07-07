//!WIDTH ${in}.w 8 *
//!HEIGHT ${in}.h 8 *
#define HPIXSZ 8
#define VPIXSZ 8


#define USE_MODULATION_LUT 1
const float D1 = ${d1:0.9};
const float D2 = ${d2:0.6561};
const float D3 = ${d2:0.};
const vec3 Z = vec3(0.);
#define ROW(v) \
	vec3(v*D3), \
	vec3(v*D2), \
	vec3(v*D1), \
	vec3(v), \
	vec3(v), \
	vec3(v*D1), \
	vec3(v*D2), \
	vec3(v*D3)

const vec3 modulate_lut[8*8] = vec3[](
	ROW(1.),
	ROW(1.),
	ROW(1.),
	ROW(1.),
	ROW(1.),
	ROW(1.),
	ROW(1.),
	ROW(0.)
);
#undef ROW

