//!HOOK MAINPRESUB
//!DESC lcd subpixel emulation, inverted channels
//!BIND HOOKED
//!WIDTH HOOKED.w 3 *
//!HEIGHT HOOKED.h 3 *
#define ROW_DIM 0.
#define PHEIGHT 3.
float pixv(float outpix, float res) {
	return (floor(outpix / 3) + 0.5) / res;
}
vec2 pt_for(vec2 outpix) {
	float u = (floor(outpix.x / 3) + 0.5) / HOOKED_size.x;
	float v =  (floor(outpix.y / PHEIGHT) + 0.5) / HOOKED_size.y;
	return vec2(u, v);
}
vec4 hook() {
	vec2 srcpt = pt_for(gl_FragCoord.xy);
	vec4 col = HOOKED_tex(srcpt);

	int which = int(mod(int(gl_FragCoord.x), 3));
	// depending on which subpixel we are, we select the appropriate colour channel.
	#define PICK(chan, index) float chan = ((which == index) ? 0. : col.chan)
	PICK(r, 0);
	PICK(g, 1);
	PICK(b, 2);
	vec3 element = vec3(r, g, b);

	// dim (or plain turn off) the first row where many TFT LCDs have their transistor banks.
	float dim = (mod(gl_FragCoord.y, PHEIGHT) < 1.) ? ROW_DIM : 1.0;
	element *= dim;

	return vec4(element, 1.0);
}
