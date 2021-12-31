// WARNING! linear light only!

vec3 f(vec3 v) {
	v = max(v, vec3(0.));
	float bm = max(max(v.r, v.g), v.b);
	float bt = v.r + v.g + v.b;

	// total brightness could be zero,
	// so check for that before performing an undefined operation (in GLES2).
	bool insanity = bt <= 0.;
	bt = insanity ? 1.0 : bt;

	float adj = bm / bt;
	//adj = pow(adj, 0.4);	
	vec3 ret = v * adj;

	// if insanity (all zeroes) we want result all zero anyway.
	ret *= float(!insanity);

	return ret;
}
