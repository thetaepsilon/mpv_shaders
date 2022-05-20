//!HOOK ${after:MAINPRESUB}
//!DESC blur kernel, 1D (configurable direction)
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h

//#include kernel
//#include? extrabind


#if ${vec4_mode:0}
#define accum_t vec4
#define MASK(x) (x)
#define RET(x) (x)
#else
#define accum_t vec3
#define MASK(x) ((x).rgb)
#define RET(x) vec4((x), 1.0)
#endif



#define TEXF ${in}_tex
#define SZ  ( ${in}_size )

const accum_t output_scale = accum_t(${e:1.0});
const vec2 stepv = vec2(${xs:0}, ${ys:0});

accum_t transform(accum_t data) {
//#optreplace data = pow(clamp(data, 0., 1.), accum_t(${input_gamma})) ;
//#optreplace data = ${input_transform};
	return data;
}

vec4 hook() {
	vec2 origin = gl_FragCoord.xy;
	accum_t total = accum_t(0.);

// XXX: could we figure out some way to re-use the centre pixel from the for-loop...
#if ${load_origin:0}
	accum_t original_raw = MASK(TEXF(${in}_pos));
	accum_t original = transform(original_raw);
#endif

	for (int i = -kernel_radius; i <= kernel_radius; i++) {
		vec2 pix = origin + (vec2(i) * stepv);
		vec2 pt = pix / SZ;
		accum_t data = MASK(TEXF(pt));
		data = transform(data);


		int idx = i + kernel_radius;
		float m = kernel_data[idx];
		accum_t contrib = data * m;

		total += contrib;
	}

	#ifdef KERNEL_SCALE_VALUE
	total *= ( KERNEL_SCALE_VALUE );
	#endif
	total *= output_scale;


	accum_t result = total;
//#optreplace result = ${output_transform};
//#optreplace result = pow(result, accum_t(1. / float(${output_gamma})) );
	return RET(result);
}



