//!HOOK ${after:MAINPRESUB}
//!DESC separable blur kernel with mask virtual sampler: horizontal pass
//!BIND ${in}
//!SAVE blurred_horizontal_from_${in}
//!WIDTH ${in}.w ${mask_width} * ${mask_mult_x} *
//!HEIGHT ${in}.h ${mask_height} * ${mask_mult_y} *

//#include kernel
//#include mask
//#include? response_function



const vec3 pixel_mask[${mask_width} * ${mask_height}] = vec3[](
	MASK_DATA
);

const vec2 mask_mult = vec2(${mask_mult_x}, ${mask_mult_y});
const vec2 mask_size = vec2(${mask_width}, ${mask_height}) * mask_mult;

const vec2 realscale = vec2(1.) / mask_size;




vec3 vsample_core(vec2 vpix) {
	vec2 downscaled = vpix * realscale;
	vec2 realpix = floor(downscaled) + vec2(0.5);
	vec2 real_pt = realpix / ${in}_size;
	vec3 data = ${in}_tex(real_pt).rgb;
//#optreplace data = pow(data, vec3(${input_gamma}));



	vec2 modpix = floor(mod(vpix, mask_size) / mask_mult);
	int idx = (int(modpix.y) * MASK_WIDTH) + int(modpix.x);
	vec3 mask = pixel_mask[idx];
	data.rgb *= mask;

	return data;
}

vec3 vsample(vec2 vpix) {
	vec3 data = vsample_core(vpix);


#ifdef USE_RESPONSE_FUNCTIONS
#ifdef RESPONSE_FUNCTIONS_EXPECT_CLAMPED
	data = clamp(data, 0., 1.);
#endif
	data = leak_response(data);
#endif

	return data;
}





vec4 hook() {
	vec2 origin = gl_FragCoord.xy;
	vec3 total = vec3(0.);

	for (int i = -kernel_radius; i <= kernel_radius; i++) {
		vec2 pix = origin + (vec2(i, 0) * ${sscale:1.});
		vec3 data = vsample(pix);

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
//!DESC separable blur kernel with mask virtual sampler: vertical pass
//!BIND blurred_horizontal_from_${in}
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH blurred_horizontal_from_${in}.w
//!HEIGHT blurred_horizontal_from_${in}.h

//#include kernel
//#include mask
//#include? response_function

#define TEXF blurred_horizontal_from_${in}_tex
#define SZ  ( blurred_horizontal_from_${in}_size )

const float exposure = ${e:1.0};


const int mask_area = MASK_WIDTH * MASK_HEIGHT;
const vec3 pixel_mask[mask_area] = vec3[](
	MASK_DATA
);



//
//
// gah, duplication. pls copy from original...
const vec2 mask_mult = vec2(${mask_mult_x}, ${mask_mult_y});
const vec2 mask_size = vec2(${mask_width}, ${mask_height}) * mask_mult;

const vec2 realscale = vec2(1.) / mask_size;

vec3 vsample_core(vec2 vpix) {
	vec2 downscaled = vpix * realscale;
	vec2 realpix = floor(downscaled) + vec2(0.5);
	vec2 real_pt = realpix / ${in}_size;
	vec3 data = ${in}_tex(real_pt).rgb;
//#optreplace data = pow(data, vec3(${input_gamma}));



	vec2 modpix = floor(mod(vpix, mask_size) / mask_mult);
	int idx = (int(modpix.y) * MASK_WIDTH) + int(modpix.x);
	vec3 mask = pixel_mask[idx];
	data.rgb *= mask;

	return data;
}

vec3 vsample(vec2 vpix) {
	vec3 data = vsample_core(vpix);


#ifdef USE_RESPONSE_FUNCTIONS
#ifdef RESPONSE_FUNCTIONS_EXPECT_CLAMPED
	data = clamp(data, 0., 1.);
#endif
	data = leak_response(data);
#endif

	return data;
}
// end dup block
//
//



vec4 hook() {
	vec2 origin = gl_FragCoord.xy;
	vec3 total = vec3(0.);

	for (int i = -kernel_radius; i <= kernel_radius; i++) {
		vec2 pix = origin + (vec2(0, i) * ${sscale:1.});
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


	#ifdef USE_RESPONSE_FUNCTIONS
	vec3 original = vsample(origin);
	#ifdef RESPONSE_FUNCTIONS_EXPECT_CLAMPED
	original = clamp(original, 0., 1.);
	#endif
	// if the response function is in use then we need to get the actual well response too.
	// the blurred data is the leaked light.
	vec3 well = well_response(original);
	total += well;
	#endif
	

	vec3 result = total * exposure;

//#optreplace result = pow(result, vec3(1.0) / vec3(${output_gamma}) );
//#optreplace if (${ab_expr}) result = original; 

	return vec4(result, 1.);
}
