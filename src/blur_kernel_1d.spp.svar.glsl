//!HOOK ${after:MAINPRESUB}
//!DESC blur kernel, 1D (configurable direction)
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h

//#include kernel



#define TEXF ${in}_tex
#define SZ  ( ${in}_size )

const vec3 output_scale = vec3(${e:1.0});
const vec2 stepv = vec2(${xs:0}, ${ys:0});

vec4 hook() {
	vec2 origin = gl_FragCoord.xy;
	vec3 total = vec3(0.);

	for (int i = -kernel_radius; i <= kernel_radius; i++) {
		vec2 pix = origin + (vec2(i) * stepv);
		vec2 pt = pix / SZ;
		vec3 data = TEXF(pt).rgb;
//#optreplace data = pow(clamp(data, 0., 1.), vec3(${input_gamma}));

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
//#optreplace result = pow(result, vec3(1. / float(${output_gamma})));
	return vec4(result, 1.);
}



