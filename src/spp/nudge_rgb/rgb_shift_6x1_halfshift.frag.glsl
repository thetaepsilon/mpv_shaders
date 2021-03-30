//!WIDTH ${in}.w 6 *
//!HEIGHT ${in}.h 1 *

#define HPIXSZ 6
#define VPIXSZ 1

#define Z vec2(0.)
#define X(v) vec2(v, 0.)

const vec2 nudge_lut_r[] = vec2[](
	Z, Z, Z, Z, X(0.5), X(1.)
);

const vec2 nudge_lut_g[] = vec2[](
	Z, Z, Z, Z, Z, X(0.5)
);

const vec2 nudge_lut_b[] = vec2[](
	X(-0.5), Z, Z, Z, Z, Z
);



#define USE_MODULATION_LUT_X 1
#define W vec3(1.)
#define DIM 0.
#define D2 0.5
//#define DV vec3(0.5)

const vec3 modulate_lut_x[] = {
	vec3(D2, D2, DIM),
	W,
	W,
	W,
	vec3(DIM, D2, D2),
	vec3(D2, DIM, D2)
};

/*
const vec3 modulate_lut_x[] = vec3[](
	DV,
	W,
	W,
	W,
	DV,
	DV
);
*/

