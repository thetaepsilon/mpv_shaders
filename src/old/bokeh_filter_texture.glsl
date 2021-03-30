//!TEXTURE data_bokeh_weights
//!SIZE 7 7
//!FORMAT r8
//!FILTER LINEAR
0096eafeea960096ffffffffff96eaffffffffffeafefffffffffffeeaffffffffffea96ffffffffff960096eafeea9600

//!HOOK MAINPRESUB
//!DESC bokeh filter
//!BIND HOOKED
//!BIND data_bokeh_weights
const float scaler = 0.021;
#define R 3
const float tdiv = 1. / ((2.0 * R) + 1.);
vec4 hook() {
	float ox = gl_FragCoord.x;
	float oy = gl_FragCoord.y;

	vec4 total = vec4(0.);
	for (int x = -R; x <= R; x++) {
	for (int y = -R; y <= R; y++) {
		vec2 srcpix = vec2(ox + x, oy + y);
		vec2 srcpt = srcpix / HOOKED_size;
		vec4 data = HOOKED_tex(srcpt);

		float fx = ((x + R) + 0.5) * tdiv;
		float fy = ((y + R) + 0.5) * tdiv;
		float m = texture2D(data_bokeh_weights, vec2(fx, fy)).r;

		total += data * m;
	}
	}
	return total * scaler;
}

