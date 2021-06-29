const vec3 exponent = vec3(${e});
const vec3 exponent_inverse = vec3(1.) / exponent;

vec3 f(vec3 c) {
	c = max(c, vec3(0.0));
	return pow(c, exponent);
}
vec3 f_undo(vec3 c) {
	c = max(c, vec3(0.0));
	return pow(c, exponent_inverse);
}

