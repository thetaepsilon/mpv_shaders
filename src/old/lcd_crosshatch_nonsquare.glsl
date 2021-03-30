
//!HOOK MAINPRESUB
//!DESC lcd crosshatch pass (non-square logical pixels)
//!BIND HOOKED
//!WIDTH HOOKED.w 2 *
//!HEIGHT HOOKED.h 3 *
#define HPIXSZ 2
#define VPIXSZ 3
const vec4 error = vec4(1.0, 0.0, 1.0, 1.0);
bool is_border(float pix, int sz) {
	return (mod(pix, sz) < 1.0);
}
int dim(float pix, int sz) {
	return is_border(pix, sz) ? 1 : 0;
}
float pixellate(float v, int sz) {
	return floor(v / sz);
}
float intersample(float v, int sz) {
	float pix = pixellate(v, sz);
	return is_border(v, sz) ? pix : (pix + 0.5);
}
float adjust(vec3 c) {
	float brightness = (c.r + c.g + c.b) / 3.;
	return 1 - ((1 - brightness) * 0.2);
}
#define BASE_DIM 0.95
vec3 darken(vec3 c, float t) { return c * t; }
const float dim_lut[3] = float[](1.0, BASE_DIM, BASE_DIM*BASE_DIM);
vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;

	float x = pixellate(inpix.x, HPIXSZ) + 0.5;
	float y = pixellate(inpix.y, VPIXSZ) + 0.5;
	vec2 pix = vec2(intersample(inpix.x, HPIXSZ), intersample(inpix.y, VPIXSZ));
	vec4 col = HOOKED_tex(pix / HOOKED_size);

	int count = dim(inpix.x, HPIXSZ) + dim(inpix.y, VPIXSZ);
	//float l = dim_lut[count];
	float l = BASE_DIM;
	l *= (count > 0) ? adjust(col.rgb) : 1.0;

	l = (count < 2) ? l : pow(l, 2.2);
	return vec4((count > 0) ? darken(col.rgb, l) : col.rgb, 1.0);
}


