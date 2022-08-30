vec3 f(vec3 col) {
	const float minlight = ${minlight};
	const float scaler = 1. / (1. - minlight);

	vec3 chopped = (col - vec3(minlight)) * scaler;
	return max(chopped, vec3(0.));
};
