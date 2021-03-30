//!HOOK MAINPRESUB
//!DESC downsampling pass: total area per-channel maximum
//!BIND HOOKED
//!WIDTH HOOKED.w 2 /
//!HEIGHT HOOKED.h 2 /
// note: be sure to get these in the right order if they are not equal!
#define MAP_X 2
#define MAP_Y 2

vec4 hook() {
	int tx = int(gl_FragCoord.x);
	int ty = int(gl_FragCoord.y);

	int ox = tx * MAP_X;
	int oy = ty * MAP_Y;
	float r = 0, g = 0, b = 0;
	vec4 total = vec4(0.);
	for (int x = 0; x < MAP_X; x++) {
	for (int y = 0; y < MAP_Y; y++) {
		vec2 srcpix = vec2(ox + x, oy + y);
		vec2 srcpt = srcpix / HOOKED_size;
		vec4 c = HOOKED_tex(srcpt);

		r = max(r, c.r);
		g = max(g, c.g);
		b = max(b, c.b);
	}
	}
	return vec4(r, g, b, 1.0);
}
