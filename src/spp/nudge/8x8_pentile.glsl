//!WIDTH ${in}.w 8 *
//!HEIGHT ${in}.h 8 *
#define HPIXSZ 8
#define VPIXSZ 8


#define USE_MODULATION_LUT 1
const vec3 _z = vec3(0.);

// 6 green pixels, 5 red, and 4 blue.
// channel values are adjusted in LINEAR LIGHT to balance.
const vec3 _r = vec3(4./5., 0., 0.);
const vec3 _g = vec3(0., 4./6., 0.);
const vec3 _b = vec3(0., 0., 4./4.);

#define BLACK _z, _z, _z, _z, _z, _z, _z, _z
#define GREEN _z, _z, _z, _g, _z, _g, _z, _z
#define ROW1 _z, _z, _r, _z, _b, _z, _r, _z
#define ROW2 _z, _z, _b, _z, _r, _z, _b, _z


const vec3 modulate_lut[8*8] = vec3[](
	BLACK,
	GREEN,
	ROW1,
	GREEN,
	ROW2,
	GREEN,
	ROW1,
	BLACK
);
#undef ROW

