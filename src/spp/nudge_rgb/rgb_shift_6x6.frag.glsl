//!WIDTH ${in}.w 6 *
//!HEIGHT ${in}.h 6 *

#define HPIXSZ 6
#define VPIXSZ 6

#define DEF(c) vec2 nudge_lut_ ## c[] = vec2[]( R, R, R, R, R, R );

// green is central and doesn't move.
// however a mild channel bleed-over applies at the very edges.
#define H 0.25
#define Z vec2(0.)
#define R vec2(-H, 0), Z, Z, Z, Z, vec2(H, 0)
DEF(g)
#undef R

// blue is to the left, hence gets nudged that way at that edge of the pixel.
#define R vec2(-1, 0), vec2(-H, 0), Z, Z, Z, Z
DEF(b)
#undef R

// converse for red.
#define R Z, Z, Z, Z, vec2(H, 0), vec2(1, 0)
DEF(r)
#undef R

#undef Z
#undef DEF
#undef H



#if ${enable_submod:1}
//#define USE_MODULATION_LUT_X 1

#define DIM ( ${submod_dim:0.9375} )
const vec3 modulate_lut_x[] = vec3[] (
	vec3(DIM, DIM, 1.),	vec3(DIM, 1., DIM),	vec3(1., DIM, DIM)
);
#undef DIM

#endif



#define USE_MODULATION_LUT_Y 1
#define W vec3(1.)

#define ROW vec3( ${rowdim:0.9375} )
vec3 modulate_lut_y[] = vec3[] (
	ROW, W, W, W, W, ROW
);

/*
#define M(v) (1 - ( v * ${rowdip:0.125} ))
vec3 modulate_lut_y[] = vec3[] (
	vec3( M(0) , M(1) , M(2) ),
	W, W, W, W,
	vec3( M(2) , M(1) , M(0) )
);
*/
#undef M
#undef W
#undef ROW

