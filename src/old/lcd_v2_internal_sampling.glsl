//!HOOK MAINPRESUB
//!DESC colour data selection pass
//!BIND MAINPRESUB
//!SAVE pixel_src
//!WIDTH 240
//!HEIGHT 135
vec4 hook() {
	float add = (mod(frame, 2.)) * 0.5;
	float x = (gl_FragCoord.x) / 240;
	float y = (gl_FragCoord.y) / 135;

	const float w = MAINPRESUB_size.x;
	float inpix = x * w;
	float x2 = (floor(inpix) + 0.5) / w;
	const float h = MAINPRESUB_size.y;
	float y2 = (floor(y * h) + 0.5) / h;
	vec2 pt = vec2(x2, y2);
	return MAINPRESUB_tex(pt);
}


//!DESC LCD effect pass
//!HOOK MAIN
//!BIND MAIN
//!SAVE MAIN
//!BIND pixel_src
//!WIDTH pixel_src.w 5 *
//!HEIGHT pixel_src.h 5 *
#define PIXSZ 5.
const float period = 6.283185307179586 / PIXSZ;
//const float period = 3.141592653589793 / PIXSZ;
// remember: mod(x, y) = x - y * floor(x/y).
bool is_border(float pix) {
	return (mod(pix, PIXSZ) < 1.0);
}
int dim(float pix) {
	return is_border(pix) ? 1 : 0;
}
float pixellate(float v) {
	float pix = floor(v / PIXSZ);
	return is_border(v) ? pix : (pix + 0.5);
}
float sine(float v) {
	float c = max(cos(floor(v) * period), 0.0);
	float r = 1.0 - (0.5 * pow(c, 1.2));
	return min(r, 1.0);
}
//const vec3 cie_rgb_y = vec3(0.1762044, 0.8129847, 0.0108109);
const vec3 cie_rgb_y = vec3(0.2, 0.4, 0.4);
/*
vec3 darken(vec3 c, float v) {
	vec3 c1 = c * cie_rgb_y;
	float avg = (c1.r + c1.g + c1.b);
	vec3 offsets = c - vec3(avg);
	return (avg * v) + offsets;
}
*/
vec3 darken(vec3 c, float v) { return c * v; }
vec4 hook() {
	vec2 pix = vec2(pixellate(gl_FragCoord.x), pixellate(gl_FragCoord.y));
	float count = dim(gl_FragCoord.x) + dim(gl_FragCoord.y);
	float l1 = pow(0.75, float(count));
	//float l = 1.0;
	float l2 = sine(gl_FragCoord.x) * sine(gl_FragCoord.y);
	float l = l1;
	//l *= l2;
	vec4 col = pixel_src_tex(pix / pixel_src_size);
	return vec4(darken(col.rgb, l), 1.0);
}
