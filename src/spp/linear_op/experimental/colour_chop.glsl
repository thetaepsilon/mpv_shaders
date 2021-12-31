// WARNING! linear light only!

vec3 f(vec3 v) {
	float b = min(min(v.r, v.g), v.b);
	vec3 base = vec3(b);
	vec3 chopped = v - base;

	vec3 ret = mix(chopped, v, 1./16.);

	return ret;
}
