//!WIDTH HOOKED.w 3 *
//!HEIGHT HOOKED.h 3 *
#define HPIXSZ 3
#define VPIXSZ 3

const float mixv = ${r};

#define USE_MODULATION_LUT 1
#define F(v) ( ((mixv) + ((1 - mixv) * v)) * S )
#define R \
	vec3(	F(1.),	F(0.),	F(0.)	), \
	vec3(	F(0.),	F(1.),	F(0.)	), \
	vec3(	F(0.),	F(0.),	F(1.)	)
const vec3 modulate_lut[] = vec3[](
	#define S 1.
	R,
	R,
	#undef S
	#define S ${rowdim:0.875}
	R
	#undef S
);

