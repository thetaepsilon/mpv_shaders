//!HOOK MAINPRESUB
//!DESC poor man's chromatic abberation shader
//!BIND HOOKED
//!WIDTH MAINPRESUB.w 3 *
//!HEIGHT MAINPRESUB.h 3 *
#define SX 1.007
#define SY 1.007
const vec2 rshift = vec2(1./SX, 1./SY);
const vec2 gshift = vec2(1., 1.);
const vec2 bshift = vec2(SX, SY);
const vec2 renorm = vec2(0.5);
vec4 hook() {
	// work out the distortion relative to the center of the image.
	// texture coordinates are 0-1 so scale into -0.5 - 0.5 first.
	// obviously later we must reverse this.
	vec2 centered = HOOKED_pos - vec2(0.5);

	// red, green and blue get shifted by different amounts,
	// so we end up with _three_ positions to sample, one for each channel.
	// XXX: not sure if it would be more performant to separate the channels,
	// then fetch from individual textures.
	vec2 rpos = (centered * rshift) + renorm;
	vec2 gpos = (centered * gshift) + renorm;
	vec2 bpos = (centered * bshift) + renorm;

	float r = HOOKED_tex(rpos).r;
	float g = HOOKED_tex(gpos).g;
	float b = HOOKED_tex(bpos).b;

	return vec4(r, g, b, 1.);
}
