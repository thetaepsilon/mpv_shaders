//!WIDTH HOOKED.w 3 *
//!HEIGHT HOOKED.h 3 *
#define HPIXSZ 3
#define VPIXSZ 3

#define USE_MODULATION_LUT 1
const float rgb_mixv = ${ratio:0.5};
#define R(v, c) \
	v *	rgb_mixv * vec3(1.,	0.,	0.), \
	v * ((	rgb_mixv * vec3(0.,	1.,	0.)	) + c), \
	v *	rgb_mixv * vec3(0.,	0.,	1.)
#define Z vec3(0.)
const float center_mixv = 1.0 - rgb_mixv;
// "center add"
const vec3 ca = vec3(center_mixv);
const vec3 row = vec3(${rowdim:0.25});
const vec3 modulate_lut[] = vec3[](
	R(1.0, ca),
	R(1.0, ca),
	R(row, Z)
);



#define USE_DRIFT_LUT 1
#define DRIFT_LUT_IS_ABS 1
#define Y(v) vec2(0.0, v)
#define ROW(v) Y(v), Y(v), Y(v)
const vec2 drift_lut[3*3] = vec2[](
	ROW(0.),
	ROW(0.),
	ROW(0.5)
);

