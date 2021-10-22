const vec3 lt_epsilon = vec3(-1. / 1024.);

vec3 f(vec3 c) {
	// note: this value must be kept in sync with the original presel stage!
	const vec3 n = vec3(${stops:8.});
	vec3 e = vec3((c * n) - n);
	//if ((e - lt_epsilon) < -n) return 0.; // !?
	vec3 v = pow(vec3(2.0), e);
	return v;
}
