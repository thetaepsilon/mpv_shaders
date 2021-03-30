//!WIDTH ${in}.w 4 *
//!HEIGHT ${in}.h 4 *

#define HPIXSZ 4
#define VPIXSZ 4

#define DEF(c) vec2 nudge_lut_ ## c[] = vec2[]( R(-0.125), R(0), R(0.125), R(0.5) );

// green is central and doesn't move.
// (however on bottom row we still need to nudge across the gap)
#define Z vec2(0.)
#define Y(v) vec2(0, v)
#define R(v) Y(v), Y(v), Y(v), Y(v)
DEF(g)
#undef R

// blue is to the left, hence gets nudged that way at that edge of the pixel.
#define R(v) vec2(-1, v), vec2(-0.333, v), Y(v), Y(v)
DEF(b)
#undef R

// converse for red.
#define R(v) Y(v), Y(v), vec2(0.333, v), vec2(1, v)
DEF(r)
#undef R

#undef Z
#undef Y
#undef DEF



#define USE_MODULATION_LUT_Y 1
#define W vec3(1.)
const float rowsteal = 1. - ( ${rowdim:0.675} );
#define ROW(v) vec3((1. - ( v * rowsteal )))
vec3 modulate_lut_y[] = vec3[] (
	ROW(0.25), W, ROW(0.25), ROW(1.)
);
#undef W
#undef ROW

