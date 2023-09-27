
vec3 correlate_gradient(vec3 left, vec3 centre, vec3 right) {
	vec3 partial_l = centre - left;
	vec3 partial_r = right - centre;

	vec3 strength = min(abs(partial_l), abs(partial_r));
	//vec3 strength = sqrt(abs(partial_l) * abs(partial_r));
	vec3 sign_matches = vec3(greaterThan((sign(partial_l) * sign(partial_r)), vec3(0.)));

	return sign_matches * strength;
}
