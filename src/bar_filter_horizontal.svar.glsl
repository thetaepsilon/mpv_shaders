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
const float scaler = 1.0 / float(dia) * ${e:1.};

vec4 hook() {
	vec2 origin = gl_FragCoord.xy;

	vec4 total = vec4(0.);
	for (int x = -distance_l; x <= distance_r; x++) {
		vec2 srcpix = origin + vec2(float(x), 0.);
		vec2 srcpt = srcpix / SZ;
		vec4 data = TEXF(srcpt);
		total += data;
	}
	return total * scaler;
}

