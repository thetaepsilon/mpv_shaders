//!WIDTH ${in}.w 2 *
//!HEIGHT ${in}.h 2 *
#define HPIXSZ 2
#define VPIXSZ 2


#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
#define ROW(Y)	vec2(0, Y), vec2(0.5, Y)
const vec2 drift_lut[2*2] = vec2[](
	ROW(0),
	ROW(0.5)
);
#undef ROW
#undef T



#define USE_MODULATION_LUT 1
const vec3 _ns_W = vec3(1.00);
const vec3 _ns_D = vec3(1./32.);
const vec3 modulate_lut[2*2] = vec3[](
	_ns_W, _ns_W,
	_ns_D, _ns_D
);

