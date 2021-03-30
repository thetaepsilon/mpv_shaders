//!WIDTH ${in}.w 3 *
//!HEIGHT ${in}.h 3 *

#define HPIXSZ 3
#define VPIXSZ 3

#define DEF(c) vec2 nudge_lut_ ## c[] = vec2[]( R(0), R(0), R(0.5) );

// green is central and doesn't move.
// (however on bottom row we still need to nudge across the gap).
// note in this version of the LUTs the green pixel is considered straddling two output pixels.
#define Z vec2(0.)
#define Y(v) vec2(0, v)
#define R(v) Y(v), Y(v), vec2(0.5, v)
DEF(g)
#undef R

// blue is to the right.
// this means at the left edge of the pixel, blue light is coming from the pixel to the left.
#define R(v) vec2(-0.5, v), Y(v), Y(v)
DEF(b)
#undef R

// red's a bit strange, as it's to the left but straddling across groups of output pixels.
#define R(v) Y(v), vec2(0.5, v), vec2(1, v)
DEF(r)
#undef R

#undef Z
#undef Y
#undef DEF







// RGB modulation pattern where the light of a subpixel doesn't quite stretch 1 pixel wide.
// in altrow mode, this pattern is instead used for "dimming" the row gap in a different way.
#define STRIPES	vec3(1., 1., DIM),	vec3(DIM, 1., 1.),	vec3(1., DIM, 1.)

#define W vec3(1.)



#if ${altrow:0}



#define USE_MODULATION_LUT 1
#define DEFAULT_ROWDIM (24. / 32.)
#define DIM 0.9375
const vec3 modulate_lut[] = vec3[](
	W,	W,	W,
	W,	W,	W,
	STRIPES
);



#else	// altrow



#define DEFAULT_ROWDIM 0.75

#if ${enable_submod:0}

#define USE_MODULATION_LUT_X 1

#define DIM ( ${submod_dim:0.75} )
const vec3 modulate_lut_x[] = vec3[] (
	STRIPES
);
#undef DIM

#endif	// enable_submod



#endif	// altrow



#define USE_MODULATION_LUT_Y 1

#define ROW vec3( ${rowdim:DEFAULT_ROWDIM} )
vec3 modulate_lut_y[] = vec3[] (
	W, W, ROW
);
#undef ROW
#undef W

