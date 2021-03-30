//!DESC de-dithering pass, even-weighted count
//!HOOK MAINPRESUB
//!BIND HOOKED
#define HALF_SZ 1
#define THRESHOLD 0.3
// unlike some of the other shaders,
// this one actually wants to do linear interp at the corner between four pixels, so no +0.5 going on.
vec4 getpix(int x, int y) {
	vec2 px = vec2(x, y);
	vec2 pt = px / HOOKED_size;
	return HOOKED_tex(pt);
}
// decide whether this dithered colour should be considered to be merged with the reference.
bool is_same(float diff) {
	return abs(diff) < THRESHOLD;
}
bool is_same_col(vec4 col, vec4 ref) {
	vec4 diff = col - ref;
	return is_same(diff.r) && is_same(diff.g) && is_same(diff.b) && is_same(diff.a);
}
// beware the fencepost error here!
int start(int v) {
	return ((v) - HALF_SZ + 1);
}
vec4 hook() {
	vec4 reference = HOOKED_tex(HOOKED_pos);
	int inx = int(gl_FragCoord.x);
	int iny = int(gl_FragCoord.y);

	int ox = start(inx);
	int oy = start(iny);

	vec4 total = vec4(0.);
	int weight = 0;

	for (int x = 0; x < (HALF_SZ * 2); x++) {
	for (int y = 0; y < (HALF_SZ * 2); y++) {
		vec4 col = getpix(ox + x, oy + y);
		bool accept = is_same_col(col, reference);
		vec4 adj = accept ? col : vec4(0.);
		int adjw = accept ? 1 : 0;
		total += adj;
		weight += adjw;
	}
	}
	return total / weight;
}
