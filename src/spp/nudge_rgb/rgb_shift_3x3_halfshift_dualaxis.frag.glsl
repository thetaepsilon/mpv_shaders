//!WIDTH ${in}.w 3 *
//!HEIGHT ${in}.h 3 *

#define HPIXSZ 3
#define VPIXSZ 3

//#define DEF(c) vec2 nudge_lut_ ## c[] = vec2[]( R(0), R(0), R(0.5) );

// green is central and doesn't move.
// (however on bottom row we still need to nudge across the gap).
// note in this version of the LUTs the green pixel is considered straddling two output pixels.
// horizontally it's to the left and vertically towards y=0 (upwards in mpv)
#define Z vec2(0.)
#define Y(v) vec2(0, v)
#define R(v) Y(v), Y(v), vec2(0.5, v)
vec2 nudge_lut_g[] = vec2[](
	R(0),	R(0),	R(0)
);
#undef R

#define S ${vshift:0.75}

// blue is to the right.
// this means at the left edge of the pixel, blue light is coming from the pixel to the left.
#define R(v) vec2(-0.5, v), Y(v), Y(v)
vec2 nudge_lut_b[] = vec2[](
	R(-S), R(0), R(0)
);
#undef R

// red's a bit strange, as it's to the left but straddling across groups of output pixels.
#define R(v) Y(v), vec2(0.5, v), vec2(1, v)
vec2 nudge_lut_r[] = vec2[](
	R(0), R(0), R(S)
);
#undef R

#undef Z
#undef Y
#undef DEF


