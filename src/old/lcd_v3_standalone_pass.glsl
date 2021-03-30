//!HOOK MAINPRESUB
//!DESC LCD transform
//!BIND MAINPRESUB
//!WIDTH MAINPRESUB.w 3 *
//!HEIGHT MAINPRESUB.h 3 *
#define PIXSZ 3.0
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
float border_compare(vec3 a, vec3 b) {
	vec3 c = a - b;
	return max(max(abs(c.r), abs(c.g)), abs(c.b));
}
float adjust(vec3 c) {
	float brightness = (c.r + c.g + c.b) / 3.;
	return 1 - ((1 - brightness) * 0.15);
}
#define BASE_DIM 0.9
vec3 darken(vec3 c, float t) { return c * t; }
const float dim_lut[3] = float[](1.0, BASE_DIM, BASE_DIM*BASE_DIM);
vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;

	float x = pixellate(inpix.x) + 0.5;
	float y = pixellate(inpix.y) + 0.5;
	vec2 pix = vec2(intersample(inpix.x), intersample(inpix.y));
	vec4 col = MAINPRESUB_tex(pix / MAINPRESUB_size);

	int count = dim(inpix.x) + dim(inpix.y);
	//float l = dim_lut[count];
	float l = BASE_DIM;
	l *= (count > 0) ? adjust(col.rgb) : 1.0;
	

	vec4 compare = MAINPRESUB_tex(vec2(x, y) / MAINPRESUB_size);
	float difference = border_compare(col.rgb, compare.rgb);
	//l *= (1 - (difference * 1.5));
	l *= pow(2, max(-min(.5 * difference, 0.2), 0.0));

	l = (count < 2) ? l : pow(l, 2.2);
	return vec4((count > 0) ? darken(col.rgb, l) : col.rgb, 1.0);
}
