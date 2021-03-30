//!WIDTH ${in}.w 3 *
//!HEIGHT ${in}.h 3 *

#define HPIXSZ 3
#define VPIXSZ 3

#define DEF(c) vec2 nudge_lut_ ## c[] = vec2[]( R(0), R(0), R(0.5) );

// green is central and doesn't move.
// (however on bottom row we still need to nudge across the gap)
#define Z vec2(0.)
#define Y(v) vec2(0, v)
#define R(v) Y(v), Y(v), Y(v)
DEF(g)
#undef R

// blue is to the left, hence gets nudged that way at that edge of the pixel.
#define R(v) vec2(-1, v), Y(v), Y(v)
DEF(b)
#undef R

// converse for red.
#define R(v) Y(v), Y(v), vec2(1, v)
DEF(r)
#undef R

#undef Z
#undef Y
#undef DEF



#if ${enable_submod:1}
#define USE_MODULATION_LUT_X 1

#define DIM ( ${submod_dim:0.9375} )
const vec3 modulate_lut_x[] = vec3[] (
	vec3(DIM, DIM, 1.),	vec3(DIM, 1., DIM),	vec3(1., DIM, DIM)
);
#undef DIM

#endif



#define USE_MODULATION_LUT_Y 1
#define W vec3(1.)
#define ROW vec3( ${rowdim:0.75} )
vec3 modulate_lut_y[] = vec3[] (
	W, W, ROW
);
#undef W
#undef ROW

