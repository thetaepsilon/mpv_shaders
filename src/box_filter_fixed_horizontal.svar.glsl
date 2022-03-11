//!HOOK ${after:MAINPRESUB}
//!BIND ${in}
//!DESC radius ${r:1} even box filter
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h
#define SZ ${in}_size
#define TEXF ${in}_tex





const int radius = ${r:1};
const int dia = (2 * radius) + 1;
const float scaler = float(${e:1}) / float(dia);

vec4 hook() {
	vec2 origin = gl_FragCoord.xy;

	vec3 total = vec3(0.);
	for (int x = -radius; x <= radius; x++) {

		vec2 srcpix = origin + vec2(float(x), 0.);
		vec2 srcpt = srcpix / SZ;
		vec3 data = TEXF(srcpt).rgb;
//#optreplace data = pow(clamp(data, 0., 1.), vec3(${input_gamma}));
		total += data;

	}
	vec3 result = total * scaler;
//#optreplace result.rgb = pow(result.rgb, vec3(1.) / vec3(${output_gamma}));
	return vec4(result, 1.);
}

