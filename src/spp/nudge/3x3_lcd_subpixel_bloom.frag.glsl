//!WIDTH HOOKED.w 3 *
//!HEIGHT HOOKED.h 3 *
#define HPIXSZ 3
#define VPIXSZ 3



#define USE_MODULATION_LUT 1
const float channel_boost = ${channel_boost:0};
#define W(v)	(float(v) / (channel_boost + float(${bloom_tightness})) )


#define ROW	vec3(W(2), W(1), 0),	vec3(1.),	vec3(0., W(1), W(2))

#define Z	vec3(0.)

const vec3 modulate_lut[3*3] = vec3[](
	ROW,
	ROW,
	Z, Z, Z
);
#undef ROW

