//!WIDTH ${in}.w 5 *
//!HEIGHT ${in}.h 5 *
#define HPIXSZ 5
#define VPIXSZ 5


#define USE_MODULATION_LUT 1
#define ROW(v)	vec3(0), vec3(0), vec3(v), vec3(0), vec3(0)
const vec3 modulate_lut[5*5] = vec3[](
	ROW(0),
	ROW(1),
	ROW(1),
	ROW(1),
	ROW(0)
);
#undef ROW

