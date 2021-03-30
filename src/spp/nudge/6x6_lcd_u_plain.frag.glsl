//!WIDTH HOOKED.w 6 *
//!HEIGHT HOOKED.h 6 *
#define HPIXSZ 6
#define VPIXSZ 6


#define USE_MODULATION_LUT 1
#define ROW(v)	vec3(0), vec3(0), vec3(v), vec3(v), vec3(0), vec3(0)
const vec3 modulate_lut[6*6] = vec3[](
	ROW(0),
	ROW(1),
	ROW(1),
	ROW(1),
	ROW(1),
	ROW(0)
);
#undef ROW

