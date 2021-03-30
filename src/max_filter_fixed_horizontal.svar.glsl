//!HOOK ${after:MAINPRESUB}
//!BIND ${in}
//!DESC radius ${r:1} even neighbour filter
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h
//!COMPONENTS 3
#define SZ ${in}_size
#define TEXF ${in}_tex





const int radius = ${r:1};
#define F2VEC3(v1, v2) (vec3(F2(v1.r, v2.r), F2(v1.g, v2.g), F2(v1.b, v2.b)))
vec3 max3(vec3 a, vec3 b) {
	#define F2 max
	return F2VEC3(a, b);
	#undef F2
}
vec4 hook() {
	float ox = gl_FragCoord.x;
	float oy = gl_FragCoord.y;

	vec3 m = vec3(0.);
	for (int x = -radius; x <= radius; x++) {
		vec2 srcpix = vec2(ox + x, oy);
		vec2 srcpt = srcpix / SZ;
		vec3 data = TEXF(srcpt).rgb;
		m = max3(m, data);
	}
	return vec4(m, 1.);
}

