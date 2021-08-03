// WARNING! linear light only!
// use gamma controls if needed.

vec3 f(vec3 v) {
	v = pow(v, vec3(${input_gamma:1.0}) );
	v *= vec3(${input_gain:1.0});	
	vec3 mapped = v / (v + vec3(1.0));
	vec3 ret = pow(mapped, vec3(1.0) / vec3(${output_gamma:1.0}) );
	return ret;
}
