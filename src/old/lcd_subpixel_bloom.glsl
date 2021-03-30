//!HOOK MAINPRESUB
//!DESC lcd subpixel bloom effect
//!BIND HOOKED
//!WIDTH HOOKED.w 3 *
//!HEIGHT HOOKED.h 3 *
const vec4 error = vec4(1.0, 0.0, 1.0, 1.0);
float nearest_pixel_1d(float v, float res) {
	return (floor(v * res) + 0.5);
}
vec2 nearest_pixel(vec2 uv) {
	float u = nearest_pixel_1d(uv.x, HOOKED_size.x);
	float v = nearest_pixel_1d(uv.y, HOOKED_size.y);
	return vec2(u, v);
}
vec4 getpixel(vec2 pix_pos) {
	return HOOKED_tex(pix_pos / HOOKED_size);
}
#define PI 3.141592653589793
float ccos(float v) {
	return max(sqrt(cos(v * PI)), 0);
}
vec4 hook() {
	vec2 pix = nearest_pixel(HOOKED_pos);
	// subpixel X position, needed for bloom sampling.
	// towards the edges of a pixel, the center green (assuming RGB order)
	// fades out, reducing the overall intensity.
	// furthermore on e.g. the right side, the adjacent red will bleed over too.
	vec2 sr = HOOKED_pos * HOOKED_size;
	float xr = sr.x;
	float sel = fract(xr) - 0.5;	// center weighted, zero is center

	float ox = pix.x;
	vec4 center = getpixel(pix);
	pix.x = ox - 1;
	vec4 left = getpixel(pix);
	pix.x = ox + 1;
	vec4 right = getpixel(pix);

	// in total, we have five components potentially in effect at any point for a given input pixel:
	// the three subpixels of the current pixel, the blue subpix of the pixel to the left,
	// and the red subpixel of the right pixel.
	// central green has most weight in the center,
	// current pixel red/blue have most weight in their respective spots
	// (which is -/+ 1/3rd pixel distance respectively),
	// with additional bleed from the adjacent subpixels.

	// heck, let's try circular curve.
	// we don't have to clamp g here as in this interval (-pi/2 to pi/2)
	// cosine never goes below zero.
	float g = sqrt(cos(sel * PI)) * center.g;
	// two contributing factors: our subpixel, plus the far neighbouring one.
	float r = (ccos(sel + 0.3333) * center.r) + (ccos(sel - 0.6666) * right.r);
	float b = (ccos(sel - 0.3333) * center.b) + (ccos(sel + 0.6666) * left.b);

	// finally we insert a rudimentary row gap.
	// on TFTs for instancce the transistors block some light,
	// causing the row line effect,
	// whereas the above tries to simulate column lines caused by subpixel interaction.
	//float ysel = fract(sr.y) - 0.5;
	//float s = 0.66 + (ccos(ysel) * 0.33);
	float ysel = min(fract(sr.y), 0.5) * 1.0;	// no, not center weighted this time...
	float s = 1 - (ccos(ysel) * 0.25);
	// FIXME: this gets harshly truncated at one edge!

	return vec4(r*s, g*s, b*s, 1.0);
}
