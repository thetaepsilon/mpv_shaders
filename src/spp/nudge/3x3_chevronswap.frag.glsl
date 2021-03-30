//!WIDTH HOOKED.w 3 *
//!HEIGHT HOOKED.h 3 *
#define HPIXSZ 3
#define VPIXSZ 3


#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
// remember, despite GLSL convention mpv arranges for down to be +Y.
const float _n = 0.5;
const vec2 up = vec2(0, -_n);
const vec2 down = vec2(0, _n);
const vec2 left = vec2(-_n, 0);
const vec2 right = vec2(_n, 0);
const vec2 z = vec2(0);
const vec2 drift_lut[3*3] = vec2[](
	z,	up,	z,
	left,	z,	right,
	z,	down,	z
);

