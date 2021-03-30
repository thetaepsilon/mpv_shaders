//!WIDTH HOOKED.w 2 *
//!HEIGHT HOOKED.h 2 *
#define HPIXSZ 2
#define VPIXSZ 2


#define USE_DRIFT_LUT 1
#define V 0.75
#define S vec2(0., 0.5)
#define Z vec2(0.)
vec2 drift_lut[] = vec2[](
	Z, Z,
	S, S
);
#undef S
#undef V

#define USE_MODULATION_LUT 1
#define M(v) (1.0 -  ( v * ${dim:0.1875} ))
#define R vec3(M(2),	M(1),	M(0)	), vec3(M(0), 	M(1),	M(2)	)
const vec3 modulate_lut[] = vec3[](
	R,
	R
);
#undef M
#undef R

