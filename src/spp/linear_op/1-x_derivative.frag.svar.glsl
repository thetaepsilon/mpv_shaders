vec3 f(vec3 v) {	
//#optreplace v = pow(v, vec3(${gamma}));

	v = (2 * v) - (v * v);

//#optreplace v = pow(v, vec3( 1. / vec3(${output_gamma}) ));
	return v;
}
