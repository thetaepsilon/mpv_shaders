//!HOOK MAINPRESUB
//!DESC LCD crosshatch effect, interlacing
//!BIND HOOKED
//!WIDTH MAINPRESUB.w 2 *
//!HEIGHT MAINPRESUB.h 2 *
#define PIXSZ 2.0
const vec4 error = vec4(1.0, 0.0, 1.0, 1.0);
bool is_border(float pix) {
	return (mod(pix, PIXSZ) < 1.0);
}
int dim(float pix) {
	return is_border(pix) ? 1 : 0;
}
float pixellate(float v) {
	return floor(v / PIXSZ);
}
float intersample(float v) {
	float pix = pixellate(v);
	return is_border(v) ? pix : (pix + 0.5);
}
float adjust(vec3 c) {
	float brightness = (c.r + c.g + c.b) / 3.;
	return 1 - ((1 - brightness) * 0.15);
}
vec3 darken(vec3 c, float t) { return c * t; }
const float dim_lut[3] = float[](1.0, 0.9, 0.8);
vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;
	float add = (mod(frame, 2.));
	inpix.x -= add;
	inpix.y -= add;

	float x = pixellate(inpix.x) + 0.5;
	float y = pixellate(inpix.y) + 0.5;
	vec2 pix = vec2(intersample(inpix.x), intersample(inpix.y));
	vec4 col = HOOKED_tex(pix / HOOKED_size);

	int count = dim(inpix.x) + dim(inpix.y);
	float l = dim_lut[count];
	l *= (count > 0) ? adjust(col.rgb) : 1.0;

	return vec4(darken(col.rgb, l), 1.0);
}

