//!HOOK ${after:MAINPRESUB}
//!DESC repeat image tiler, set multiple of input image
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in} ${x} *
//!HEIGHT ${in} ${y} *

#define SZ ${in}_size
#define TEX ${in}_tex

vec4 hook() {
	float x = mod(gl_FragCoord.x, SZ.x);
	float y = mod(gl_FragCoord.y, SZ.y);

	vec2 pt = vec2(x, y) / SZ;
	return TEX(pt);
}

