#define USE_RESPONSE_FUNCTIONS 1
#define RESPONSE_FUNCTIONS_EXPECT_CLAMPED 1

#define RESPONSE_FUNCTION_WELL_MAX 1.0
vec3 well_response(vec3 c) {
	return c;
}

#define RESPONSE_FUNCTION_LEAK_MAX 1.0
vec3 leak_response(vec3 c) {
	return c;
}

