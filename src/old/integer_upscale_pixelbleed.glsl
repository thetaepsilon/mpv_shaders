//!HOOK MAINPRESUB
//!DESC integer upscaling pass with pixel colour bleed
//!BIND HOOKED
//!WIDTH HOOKED.w 2 *
//!HEIGHT HOOKED.h 2 *
#define HPIXSZ 2
#define VPIXSZ 2
const vec2 scale = vec2(1./float(HPIXSZ), 1./float(VPIXSZ));

#define S 0.75
float drift_lut_h[HPIXSZ] = float[](S, S);
float drift_lut_v[VPIXSZ] = float[](S, S);
#undef S

#define M(v) (1.0 -  ( v * 0.1875 ))
const vec3 modulate_lut[] = vec3[](
	vec3(	M(2),	M(1),	M(0)	),
	vec3(	M(0), 	M(1),	M(2)	)
);
#undef M


vec2 nearest(vec2 pix) {
	return vec2(floor(pix.x), floor(pix.y)) + vec2(0.5);
}
const int row_trigger = VPIXSZ - 1;
vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;
	vec2 downscaled = inpix * scale;
	vec2 nearest_pix = nearest(downscaled);

	// we have the original linear position (downscaled)
	// and the nearest center of pixel (nearest_pix).
	// we then scale the difference a very small amount towards the linear position,
	// such that we get a position that mixes a trace amount of the neighbouring pixel in.
	int which_x = int(mod(gl_FragCoord.x, float(HPIXSZ)));
	int which_y = int(mod(gl_FragCoord.y, float(VPIXSZ)));
	vec2 drift_multiplier = vec2(drift_lut_h[which_x], drift_lut_v[which_y]);

	vec2 unity_drift = downscaled - nearest_pix;
	vec2 drift = (unity_drift * drift_multiplier);
	vec2 srcpix = nearest_pix + drift;

	// debug modes below...
	//srcpix = nearest_pix;
	//srcpix = downscaled;
	//srcpix = nearest_pix + unity_drift;

	vec2 pos = srcpix / HOOKED_size;
	vec4 data = HOOKED_tex(pos);

	data.rgb = data.rgb * modulate_lut[which_x];
	if (which_y == row_trigger) data.rgb *= 0.875;
	return data;
}

