//!DESC colour dithering, simple floor method
//!HOOK MAINPRESUB
//!BIND HOOKED
const int frac = 7;
float dither(float v) {
	float scaled = v * frac;
	float floored = floor(scaled);
	float dithered = floored / frac;
	return dithered;
}
vec4 dither_colour(vec4 i) {
	float r = dither(i.r);
	float g = dither(i.g);
	float b = dither(i.b);
	float a = dither(i.a);
	vec4 result = vec4(r, g, b, a);
	return result;
}
vec4 hook() {
	vec4 input_c = HOOKED_tex(HOOKED_pos);
	vec4 output_c = dither_colour(input_c);
	return output_c;
}
