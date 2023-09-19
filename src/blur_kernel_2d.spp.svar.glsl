//!HOOK ${after:MAINPRESUB}
//!DESC blur kernel, 2D RGB (obvious warning: likely O(r^2)
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h

#define S(v) ((2*v) + 1)
#define KERNEL_SIZE S(KERNEL_RADIUS_X) * S(KERNEL_RADIUS_Y)

//#include kernel



#define TEXF ${in}_tex
#define SZ  ( ${in}_size )

const float output_scale = ${e:1.0};
const int kernel_radius_x = KERNEL_RADIUS_X;
const int kernel_radius_y = KERNEL_RADIUS_Y;
const int kernel_size = S(kernel_radius_x) * S(kernel_radius_y);


#ifndef KERNEL_DIRECT_DEFINE
#define XR(v) (v) ,
const vec3 kernel_data[kernel_size] = vec3[](
	KERNEL_DATA
);
#undef XR

const vec3 kernel_scale = vec3( KERNEL_SCALE );
#endif // KERNEL_DIRECT_DEFINE



vec3 transform(vec3 data) {
//#optreplace data = ${input_transform};
        return data;
}

vec4 hook() {
	vec2 origin = gl_FragCoord.xy;
	vec3 total = vec3(0.);

#if ${load_origin:0}
        vec3 original_raw = TEXF(${in}_pos).rgb;
        vec3 original = transform(original_raw);
#endif

	#define LOOP(d) int d = -kernel_radius_ ## d; d <= kernel_radius_ ## d; d++

	for (LOOP(y)) {
	for (LOOP(x)) {
		vec2 pix = origin + vec2(x, y);
		vec2 pt = pix / SZ;
		vec3 data = TEXF(pt).rgb;
		data = transform(data);

		int idx_x = x + kernel_radius_x;
		int idx_y = y + kernel_radius_y;
		int idx = (idx_y * S(kernel_radius_x)) + idx_x;
		vec3 m = kernel_data[idx];
		vec3 contrib = data * m;

		total += contrib;
	}
	}
	#undef LOOP

	total *= ( kernel_scale );
	total *= output_scale;

	vec3 result = total;
//#optreplace result = ${output_transform};

	return vec4(result, 1.);
}



