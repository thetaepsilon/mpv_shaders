//!WIDTH ${in}.w 5 *
//!HEIGHT ${in}.h 5 *
#define HPIXSZ 5
#define VPIXSZ 5


#define USE_MODULATION_LUT 1
const float D1 = ${d1:0.5};
const float D2 = ${d2:0.};
#define ROW(v)	vec3(v*D2), vec3(v*D1), vec3(v), vec3(v*D1), vec3(v*D2)
const vec3 modulate_lut[5*5] = vec3[](
	ROW(1),
	ROW(1),
	ROW(1),
	ROW(1),
	ROW(0)
);
#undef ROW

#define MODULATE_BASE_COLOR ${basecol:0, 0, 0}

