//!WIDTH ${in}.w 10 *
//!HEIGHT ${in}.h 10 *
#define HPIXSZ 10
#define VPIXSZ 10

#define USE_MODULATION_LUT 1
#define ON vec3(1.)
#define OFF vec3(0.)
#define ROW	OFF,	ON, ON, ON, ON,	ON, ON, ON, ON,	OFF
#define BOTTOM	OFF,	OFF, OFF, OFF, OFF,	OFF, OFF, OFF, OFF,	OFF
const vec3 modulate_lut[] = vec3[](
	ROW,
	ROW, ROW, ROW, ROW,
	ROW, ROW, ROW, ROW,
	BOTTOM
);

