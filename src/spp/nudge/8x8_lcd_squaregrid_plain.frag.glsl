//!WIDTH ${in}.w 8 *
//!HEIGHT ${in}.h 8 *
#define HPIXSZ 8
#define VPIXSZ 8


#define USE_MODULATION_LUT 1
#define ROW(v)	vec3(0), vec3(v), vec3(v), vec3(v), vec3(v), vec3(v), vec3(v), vec3(v)
const vec3 modulate_lut[8*8] = vec3[](
	ROW(1),
	ROW(1),
	ROW(1),
	ROW(1),
	ROW(1),
	ROW(1),
	ROW(1),
	ROW(0)
);
#undef ROW

