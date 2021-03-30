vec3 f(vec3 v) {	
	return pow(clamp(v, 0., 1.), vec3(${e:2.}));
}
