#define USE_RESPONSE_FUNCTIONS 1

const vec3 response_partial_diffuse_colour = vec3(${partial_diffuse_colour});

const vec3 response_partial_diffuse_remainder_colour = vec3(1.0) - response_partial_diffuse_colour;



vec3 leak_response(vec3 c) {
	return c * response_partial_diffuse_colour;
}

vec3 well_response(vec3 c) {
	return c * response_partial_diffuse_remainder_colour;
	//return c;
}

