//!HOOK MAINPRESUB
//!DESC colour data selection pass
//!BIND MAINPRESUB
//!SAVE pixel_src
//!WIDTH 240
//!HEIGHT 160
vec4 hook() {
	//if (gl_FragCoord.y < 130.) return vec4(1., 0., 0., 1.);

	float add = (mod(frame, 2.)) * 0.5;
	float x = (gl_FragCoord.x) / 240;
	float y = (gl_FragCoord.y) / 160;

	const float w = MAINPRESUB_size.x;
	float x2 = (floor(x * w) + 0.5) / w;
	const float h = MAINPRESUB_size.y;
	float y2 = (floor(y * h) + 0.5) / h;
	vec2 pt = vec2(x2, y2);
	return MAINPRESUB_tex(pt);
}

//!HOOK SCALED
//!DESC pixel grid upscaling pass
//!BIND SCALED
//!BIND pixel_src
#define PIXSZ 4.0
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
	return 1 - (((c.r + c.g + c.b) * 0.333) * 0.15);
}
#define BASE_DIM 0.95
vec3 darken(vec3 c, float t) { return c * t; }
const float dim_lut[3] = float[](1.0, BASE_DIM, BASE_DIM*BASE_DIM);
vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;
	// center the video by calculating the difference between the needed and available resolution.
	// note that if the output resolution is too small this leads to a center crop.
	// also note that technically this can wind up subtracting .5 from the original gl_FragCoords,
	// but everything we do here already has to be linear sampling aware anyway so this is fine.
	vec2 padding = SCALED_size.xy - (pixel_src_size.xy * PIXSZ);
	inpix -= padding * 0.5;
	bool xmin = (inpix.x < 0);
	bool ymin = (inpix.y < 0);
	bool xmax = (inpix.x / PIXSZ > pixel_src_size.x);
	bool ymax = (inpix.y / PIXSZ > pixel_src_size.y);
	if (xmin || ymin || xmax || ymax) discard;

	float x = pixellate(inpix.x) + 0.5;
	float y = pixellate(inpix.y) + 0.5;
	vec2 pix = vec2(intersample(inpix.x), intersample(inpix.y));
	vec4 col = pixel_src_tex(pix / pixel_src_size);

	int count = dim(inpix.x) + dim(inpix.y);
	float l = dim_lut[count];
	l *= (count > 0) ? adjust(col.rgb) : 1.0;
	

	vec4 compare = pixel_src_tex(vec2(x, y) / pixel_src_size);
	float difference = border_compare(col.rgb, compare.rgb);
	//l *= (1 - (difference * 1.5));
	l *= pow(2, max(-min(2. * difference, 0.35), 0.0));
	
	//return error;

	return vec4((count > 0) ? darken(col.rgb, l) : col.rgb, 1.0);
}
