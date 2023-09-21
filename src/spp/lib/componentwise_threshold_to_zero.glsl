
vec3 componentwise_threshold_to_zero(vec3 data, vec3 thresholds) {
	bvec3 meets_threshold = greaterThanEqual(data, thresholds);
	vec3 sent_to_zero = data * vec3(meets_threshold);
	return sent_to_zero;
}

