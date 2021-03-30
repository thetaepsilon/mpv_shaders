//!WIDTH HOOKED.w 5 *
//!HEIGHT HOOKED.h
#define HPIXSZ 5
#define VPIXSZ 1


#define USE_MODULATION_LUT 1
#define D2 0.
#define D1 (14. / 16.)
const vec3 modulate_lut[5*1] = vec3[](
	vec3(D1, 0., 0.),
	vec3(1., D1, 0.),
	vec3(D1, 1., D1),
	vec3(0., D1, 1.),
	vec3(0., 0., D1)
);
#undef D1

