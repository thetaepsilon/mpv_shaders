//!HOOK MAINPRESUB
//!BIND ${in}
//!DESC radius ${r:1} even box filter
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h
#define SZ ${in}_size
#define TEXF ${in}_tex





const int radius = ${r:1};
const int dia = (2 * radius) + 1;
const float scaler = float(${e:1}) / float(dia * dia);

vec4 hook() {
	float ox = gl_FragCoord.x;
	float oy = gl_FragCoord.y;

	vec3 total = vec3(0.);
	for (int x = -radius; x <= radius; x++) {
	for (int y = -radius; y <= radius; y++) {
		vec2 srcpix = vec2(ox + x, oy + y);
		vec2 srcpt = srcpix / SZ;
		vec3 data = TEXF(srcpt).rgb;
		total += data;
	}
	}

	vec3 result = total * scaler;
	return vec4(result, 1.);
}

