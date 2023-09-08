// safe transport helpers for storing oklab in quasi-float textures.
// e.g. some hardware, at least old intel gpus,
// don't support storing negative values under mpv's control
// (this may be an mpv format selection limitation).

const vec3 __oklab_safe_transport_bias = vec3(0., vec2(0.5));

vec3 oklab_to_safe_transport(vec3 col) {
	// only chroma tends to be negative, so re-scale only those.
	return (col * vec3(1., vec2(0.5))) + __oklab_safe_transport_bias;
}

vec3 oklab_from_safe_transport(vec3 safe) {
	return (safe - __oklab_safe_transport_bias) * vec3(1., vec2(2.0));
}
