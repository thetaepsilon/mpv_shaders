//!WIDTH HOOKED.w 4 *
//!HEIGHT HOOKED.h 4 *
#define HPIXSZ 4
#define VPIXSZ 4


#define USE_MODULATION_LUT 1
#define C(d, r, g, b) ( vec3( 1 - (d*r), 1 - (d*g), 1 - (d*b) ) )
#define D1 0.5
#define ROW(v)	(v * C(0.5, 0, 1, 2) * D1), vec3(v), vec3(v), (v * C(0.5, 2, 1, 0) * D1)
const vec3 modulate_lut[4*4] = vec3[](
	ROW(1),
	ROW(1),
	ROW(1),
	ROW(0)
);
#undef ROW

