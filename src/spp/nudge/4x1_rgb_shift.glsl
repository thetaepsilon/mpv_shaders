//!WIDTH HOOKED.w 4 *
//!HEIGHT HOOKED.h
#define HPIXSZ 4
#define VPIXSZ 1


#define USE_MODULATION_LUT 1
#define D1 0.
const vec3 modulate_lut[4*1] = vec3[](
	vec3(1., D1, D1),
	vec3(1., 1., D1),
	vec3(D1, 1., 1.),
	vec3(D1, D1, 1.)
);
#undef D1

