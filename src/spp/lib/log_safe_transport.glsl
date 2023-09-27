
const float __log_safe_transport_fixed_min = -128.;
const float __log_safe_transport_fixed_range = 256.;

vec3 log_to_safe_transport(vec3 logV) {
	logV -= vec3(__log_safe_transport_fixed_min);
	logV /= __log_safe_transport_fixed_range;
	vec3 clamped = clamp(logV, vec3(0.), vec3(1.));
	return clamped;
}

vec3 log_from_safe_transport(vec3 safe) {
	vec3 unscaled = safe * __log_safe_transport_fixed_range;
	return (unscaled + vec3(__log_safe_transport_fixed_min));
}
