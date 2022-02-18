//!HOOK ${after:MAINPRESUB}
//!DESC separable blur kernel, horizontal pass
//!BIND ${in}
//!SAVE blurred_horizontal_from_${in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h

//#include kernel

#define TEXF ${in}_tex
#define SZ  ( ${in}_size )

const float bias_f = float( ${bias:0.} );
const vec2 bias = vec2(bias_f, 0.);

// helper function for input_transform expression
vec3 unit_range(vec3 data) {
	return clamp(data, vec3(0.), vec3(1.));
}

vec4 hook() {
	vec2 origin = gl_FragCoord.xy;
	vec3 total = vec3(0.);

	for (int i = -kernel_radius; i <= kernel_radius; i++) {
		vec2 pix = origin + (vec2(i, 0) * ${sscale:1.}) + bias;
		vec2 pt = pix / SZ;
		vec3 data = TEXF(pt).rgb;
		data = clamp(data, vec3(0.), vec3(1.));
//#optreplace data = pow(data, vec3(${input_gamma}));
//#optreplace data = ${input_transform};

		int idx = i + kernel_radius;
		float m = kernel_data[idx];
		vec3 contrib = data * m;

		total += contrib;
	}

	#ifdef KERNEL_SCALE_VALUE
	total *= ( KERNEL_SCALE_VALUE );
	#endif
	return vec4(total, 1.);
}





//!HOOK ${after:MAINPRESUB}
//!DESC separable blur kernel, vertical pass
//!BIND blurred_horizontal_from_${in}
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h

//#include kernel

#define TEXF blurred_horizontal_from_${in}_tex
#define SZ  ( blurred_horizontal_from_${in}_size )

const float bias_f = float( ${bias:0.} );
const vec2 bias = vec2(0., bias_f);

const float output_scale = ${e:1.0};

vec4 hook() {
	vec2 origin = gl_FragCoord.xy;
	vec3 total = vec3(0.);
	vec3 original = ${in}_tex(${in}_pos).rgb;

	for (int i = -kernel_radius; i <= kernel_radius; i++) {
		vec2 pix = origin + (vec2(0, i) * ${sscale:1.}) + bias;
		vec2 pt = pix / SZ;
		vec3 data = TEXF(pt).rgb;

		int idx = i + kernel_radius;
		float m = kernel_data[idx];
		vec3 contrib = data * m;

		total += contrib;
	}

	#ifdef KERNEL_SCALE_VALUE
	total *= ( KERNEL_SCALE_VALUE );
	#endif
	total *= output_scale;

	vec3 result = total;
//#optreplace result = mix(original, total, ${mixv});

//#optreplace if (${ab_expr}) result = original; 

//#optreplace result = pow(result, vec3(1. / float(${output_gamma})));
//#optreplace result = ${output_transform};

	return vec4(result, 1.);
}
