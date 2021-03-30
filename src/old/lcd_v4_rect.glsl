//!HOOK MAINPRESUB
//!DESC LCD transform
//!BIND MAINPRESUB
//!WIDTH MAINPRESUB.w 4 *
//!HEIGHT MAINPRESUB.h 4 *
#define PIXSZ 4
#define LRPAD 1
const vec4 error = vec4(1.0, 0.0, 1.0, 1.0);
bool is_border(float pix) {
	return (mod(pix, PIXSZ) < 1.0);
}
int lrborder_signed(float pix) {
	int x = int(mod(pix, PIXSZ));
	if (x < LRPAD) return -1;
	if ((x + LRPAD) >= PIXSZ) return 1;
	return 0;
}
int pixellate(float v) {
	return int(v / PIXSZ);
}
float intersample(float v) {
	float pix = pixellate(v);
	return is_border(v) ? pix : (pix + 0.5);
}
float border_compare(vec3 a, vec3 b) {
	vec3 c = a - b;
	return max(max(abs(c.r), abs(c.g)), abs(c.b));
}
// 3x light:	0.84 0.92 0.33 0.60 0.25 0.15
// 4x med:	0.66 0.77 0.33 0.90 0.45 0.15
// 4x light:	0.85 0.92 0.33 0.10 0.05 0.00
#define BASE_DIM 0.54
#define LRDIM 0.63
#define EDGE_NUDGE 0.33
#define ADAPTIVE_SCALE 0.0
#define ADAPTIVE_MAX 0.0
#define ADJ_STRENGTH 0.0
float adjust(vec3 c) {
	float brightness = (c.r + c.g + c.b) / 3.;
	return 1 - ((1 - brightness) * ADJ_STRENGTH);
}
vec3 darken(vec3 c, float t) { return c * t; }
const float dim_lut[3] = float[](1.0, BASE_DIM, BASE_DIM*BASE_DIM);
vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;

	float x = pixellate(inpix.x) + 0.5;
	float y = pixellate(inpix.y) + 0.5;

	bool row = is_border(inpix.y);
	//float l = dim_lut[count];
	float l = row ? BASE_DIM : 1.0;
	//l *= row ? adjust(col.rgb) : 1.0;
	int whichedge = lrborder_signed(inpix.x);
	bool edge = (whichedge != 0);
	l = (edge && !row) ? (l * LRDIM) : l;

	//vec2 pix = vec2(intersample(inpix.x), intersample(inpix.y));
	vec2 pix = vec2(x + (whichedge * EDGE_NUDGE), intersample(inpix.y));
	vec4 col = MAINPRESUB_tex(pix / MAINPRESUB_size);

	vec4 compare = MAINPRESUB_tex(vec2(x, y) / MAINPRESUB_size);
	float difference = border_compare(col.rgb, compare.rgb);
	//l *= (1 - (difference * 1.5));
	l *= pow(2, -min(ADAPTIVE_SCALE * difference, ADAPTIVE_MAX));

	//l = (!row) ? l : pow(l, 2.2);
	return vec4(row || edge ? darken(col.rgb, l) : col.rgb, 1.0);
}
