vec3 f(vec3 v) {	
//#optreplace v = pow(v, vec3(${gamma}));

	v = (2 * v) - (v * v);

	return v;
}
