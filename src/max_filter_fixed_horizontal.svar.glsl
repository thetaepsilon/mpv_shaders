//!HOOK ${after:MAINPRESUB}
//!BIND ${in}
//!DESC radius ${r:1} even neighbour filter
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h
#define SZ ${in}_size
#define TEXF ${in}_tex



vec3 accumulate(vec3 m, vec3 data) {
#if ${min_mode:0}
	m = min(m, data);
#else
	m = max(m, data);
#endif
	return m;
}

#if ${min_mode:0}
const float initial = 1.0;
#else
const float initial = 0.0;
#endif



const int radius = ${r:1};

vec4 hook() {
	vec2 origin = gl_FragCoord.xy;

	vec3 m = vec3(initial);
	for (int x = -radius; x <= radius; x++) {
		vec2 srcpix = origin + vec2(float(x), 0.0);
		vec2 srcpt = srcpix / SZ;
		vec3 data = TEXF(srcpt).rgb;
		m = accumulate(m, data);
	}
	return vec4(m, 1.);
}

