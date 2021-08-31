//!WIDTH ${in}.w 1 *
//!HEIGHT ${in}.h 6 *
#define HPIXSZ 1
#define VPIXSZ 6


#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
#define Z vec2(0.)
const float N1 = float(${n1:0.33});
const float UN1 = float(${un1:-N1});
vec2 drift_lut[] = vec2[](
	vec2(0., UN1),
	Z,
	Z,
	Z,
	Z,
	vec2(0., N1)
);
#undef Z

#define USE_MODULATION_LUT 1
#define W vec3(1.)
const float D1 = float(${d1:0.5});
const float UD1 = float(${ud1:D1});
const vec3 modulate_lut[] = vec3[](
	vec3(UD1),
	W,
	W,
	W,
	W,
	vec3(D1)
);
#undef W

