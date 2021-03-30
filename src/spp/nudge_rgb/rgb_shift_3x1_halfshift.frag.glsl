//!WIDTH ${in}.w 3 *

#define HPIXSZ 3
#define VPIXSZ 1

#define DEF(c) vec2 nudge_lut_ ## c[] = vec2[]( R(0) );

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

