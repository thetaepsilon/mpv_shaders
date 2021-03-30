//!WIDTH ${in}.w 2 *
//!HEIGHT ${in}.h 2 *

#define HPIXSZ 2
#define VPIXSZ 2

#define ROWS R(0), R(0.5)

#define DEF(c) vec2 nudge_lut_ ## c[] = vec2[]( ROWS );

// green is central and doesn't move.
// (however on bottom row we still need to nudge across the gap)
#define Z vec2(0.)
#define Y(v) vec2(0, v)
#define R(v) Y(v), Y(v)
DEF(g)
#undef R

// blue is to the left, hence gets nudged that way at that edge of the pixel.
#define R(v) vec2(-0.666666, v), Y(v)
DEF(b)
#undef R

// converse for red.
#define R(v) Y(v), vec2(0.666666, v)
DEF(r)
#undef R

#undef Z
#undef Y
#undef DEF



#if ${enable_submod:0}
#define USE_MODULATION_LUT_X 1

const float dim = 1 - ( ${submod_dim:0.9375} );
#define M(v) (1 - (v * dim))
const vec3 modulate_lut_x[] = vec3[] (
	vec3(M(0), M(1), M(2)), vec3(M(2), M(1), M(0))
);

#endif





#define USE_MODULATION_LUT_Y 1
#define W vec3(1.)

#define ROW vec3( ${rowdim:0.5} )
vec3 modulate_lut_y[] = vec3[] (
	W, ROW
);

#undef W
#undef ROW


