//!WIDTH ${in}.w 3 *
//!HEIGHT ${in}.h 3 *
#define HPIXSZ 3
#define VPIXSZ 3



#define USE_MODULATION_LUT 1
#define ROW	vec3(0), vec3(1.0), vec3(0.125)
const vec3 modulate_lut[3*3] = vec3[](
	ROW,
	ROW,
	vec3(0.), vec3(0.), vec3(0.)
);
#undef ROW

