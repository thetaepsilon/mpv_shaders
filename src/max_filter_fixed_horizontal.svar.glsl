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

vec4 hook() {
	vec2 origin = gl_FragCoord.xy;

	vec3 m = vec3(0.);
	for (int x = -radius; x <= radius; x++) {
		vec2 srcpix = origin + vec2(float(x), 0.0);
		vec2 srcpt = srcpix / SZ;
		vec3 data = TEXF(srcpt).rgb;
		m = max(m, data);
	}
	return vec4(m, 1.);
}

