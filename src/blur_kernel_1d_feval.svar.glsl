//!HOOK ${after:MAINPRESUB}
//!DESC blur kernel, 1D, function eval
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h
//!WHEN ${xs:0} ${ys:0} +



float kernel_function(float dist) {
	return ${function};
}



#define TEXF ${in}_tex
#define SZ  ( ${in}_size )

const float output_scale = ${e:1.0};
const vec2 stepv = vec2(${xs:0}, ${ys:0});

// when xs and ys are both non-zero, normally the distance given to the function is adjusted,
// using the regular pythagoras formula for 2D euclidian distance.
// however the user can optionally turn that off so it's always 1.
#if ${no_diagonal_distance:0}
const float step_distance = 1.0;
#else
const float step_distance = length(stepv);
#endif

const int kernel_radius = ${r};



vec4 hook() {
	vec2 origin = gl_FragCoord.xy;
	vec3 total = vec3(0.);
	float weight = 0.;

	for (int i = -kernel_radius; i <= kernel_radius; i++) {
		vec2 pix = origin + (vec2(i) * stepv);
		vec2 pt = pix / SZ;
		vec3 data = TEXF(pt).rgb;

		float dist = abs(i) * step_distance;
		float w = kernel_function(dist);
		vec3 contrib = data * w;

		total += contrib;
		weight += w;
	}

	total /= weight;
	total *= output_scale;


	vec3 result = total;
	return vec4(result, 1.);
}



