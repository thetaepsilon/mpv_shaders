//!HOOK SCALED
//!DESC repeat image tiler
//!BIND MAINPRESUB

#define SZ MAINPRESUB_size
#define TEX MAINPRESUB_tex

vec4 hook() {
	float x = mod(gl_FragCoord.x, SZ.x);
	float y = mod(gl_FragCoord.y, SZ.y);

	vec2 pt = vec2(x, y) / SZ;
	return TEX(pt);
}
