//!HOOK ${after:MAINPRESUB}
//!BIND ${in}
//!DESC asymmetrical bar filter
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h
#define SZ ${in}_size
#define TEXF ${in}_tex



const int distance_r = ${r};
const int distance_l = ${l};
const int dia = distance_r + distance_l + 1;
const float scaler = 1 / float(dia) * ${e:1.};

vec4 hook() {
	float ox = gl_FragCoord.x;
	float oy = gl_FragCoord.y;

	vec4 total = vec4(0.);
	for (int x = -distance_l; x <= distance_r; x++) {
		vec2 srcpix = vec2(ox + x, oy);
		vec2 srcpt = srcpix / SZ;
		vec4 data = TEXF(srcpt);
		total += data;
	}
	return total * scaler;
}

