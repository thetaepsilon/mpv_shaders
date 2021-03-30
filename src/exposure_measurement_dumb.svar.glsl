//!HOOK MAINPRESUB
//!DESC max brightness finder (WARNING: all done in one pixel, expensive AF)
//!BIND ${in:HOOKED}
//!SAVE ${out:maxbrightness}
//!WIDTH 1
//!HEIGHT 1
//!COMPONENTS 1
#define SZ ( ${in:HOOKED}_size )
#define TEXF ${in:HOOKED}_tex

vec4 hook() {
	vec3 maxbright = vec3(0.);
	for (int x = 0; x < SZ.x; x++) {
	for (int y = 0; y < SZ.y; y++) {
		vec2 pix = vec2(x, y) + vec2(0.5);
		vec2 pt = pix / SZ;
		vec3 data = TEXF(pt).rgb;
		#define M(c) (max(maxbright.c, data.c))
		maxbright = vec3(M(r), M(g), M(b));
		#undef M
	}
	}

	float b = max(maxbright.r, max(maxbright.g, maxbright.b));
	return vec4(b);
	//return vec4(maxbright, 1.);
}

