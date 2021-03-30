//!WIDTH HOOKED.w 4 *
//!HEIGHT HOOKED.h 4 *
#define HPIXSZ 4
#define VPIXSZ 4


#define USE_MODULATION_LUT 1
#define ROW(v)	vec3(0), vec3(v), vec3(0), vec3(0)
const vec3 modulate_lut[4*4] = vec3[](
	ROW(1),
	ROW(1),
	ROW(1),
	ROW(0)
);
#undef ROW

