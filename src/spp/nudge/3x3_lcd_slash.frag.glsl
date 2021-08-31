//!WIDTH ${in}.w 3 *
//!HEIGHT ${in}.h 3 *
#define HPIXSZ 3
#define VPIXSZ 3


#define USE_MODULATION_LUT 1
const vec3 ON = vec3(1.);
const vec3 Z = vec3(0.);
const vec3 modulate_lut[3*3] = vec3[](
	Z,		Z,		vec3(0.5),
	Z,		vec3(0.5),	ON,
	Z,		ON,		Z
);
#undef ROW

