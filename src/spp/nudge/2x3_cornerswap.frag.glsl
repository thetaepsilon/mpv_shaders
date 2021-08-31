//!WIDTH ${in}.w 2 *
//!HEIGHT ${in}.h 3 *
#define HPIXSZ 2
#define VPIXSZ 3


#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
// remember, despite GLSL convention mpv arranges for down to be +Y.
const float _n = 0.25;
const float _h = 0.125;
const vec2 upleft = vec2(-_n, -_n);
const vec2 downleft = vec2(-_n, _n);
const vec2 upright = vec2(_n, -_n);
const vec2 downright = vec2(_n, _n);
const vec2 z = vec2(0);
const vec2 drift_lut[2*3] = vec2[](
	upleft,	upright,
	vec2(-_h, 0),	vec2(_h, 0),
	downleft,	downright
);

