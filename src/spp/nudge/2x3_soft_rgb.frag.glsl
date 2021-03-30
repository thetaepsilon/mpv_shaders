//!WIDTH HOOKED.w 2 *
//!HEIGHT HOOKED.h 3 *
#define HPIXSZ 2
#define VPIXSZ 3



#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
#define ROW(v) vec2(0, v), vec2(0, v)
const vec2 drift_lut[] = vec2[](
	ROW(0),
	ROW(0),
	ROW(0.5)
);



#define USE_MODULATION_LUT 1
#define M(v) (1.0 -  ( v * ${dim:0.375} ))
#define R(v2) vec3(M(2) * v2, M(1) * v2, M(0) * v2 ), vec3(M(0) * v2, M(1) * v2, M(2) * v2)
const float rowdim = ${rowdim:0.75};
const vec3 modulate_lut[] = vec3[](
	R(1),
	R(1),
	R(rowdim)
);
#undef M
#undef R

