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

int pixellate(float v) {
	return int(v / PIXSZ);
}
float intersample(float v) {
	float pix = pixellate(v);
	return is_border(v) ? pix : (pix + 0.5);
}
int lrborder_signed(float pix) {
	int x = int(mod(pix, PIXSZ));
	if (x < LRPAD) return -1;
	if ((x + LRPAD) >= PIXSZ) return 1;
	return 0;
}

//#define BASE_DIM 0.5
//#define LRDIM 0.75
#define BASE_DIM 0.75
#define LRDIM 0.875

vec3 darken(vec3 c, float t) { return c * t; }
const float nudge_lut[4] = float[](-0.125, -0.0625, 0.0625, 0.125);
vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;

	float x = pixellate(inpix.x) + 0.5;
	float y = pixellate(inpix.y) + 0.5;

	bool row = is_border(inpix.y);
	float l = 1.0;
	l *= row ? BASE_DIM : 1.0;
	
	int whichedge = lrborder_signed(inpix.x);
	bool edge = (whichedge != 0);
	l = (edge && !row) ? (l * LRDIM) : l;

	int pick = int(mod(gl_FragCoord.x, PIXSZ));
	float nudge = nudge_lut[pick];

	//vec2 pix = vec2(intersample(inpix.x), intersample(inpix.y));
	vec2 pix = vec2(x + nudge, intersample(inpix.y));
	vec4 col = MAINPRESUB_tex(pix / MAINPRESUB_size);

	//l = (!row) ? l : pow(l, 2.2);
	return vec4(row || edge ? darken(col.rgb, l) : col.rgb, 1.0);
}
