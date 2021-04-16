#define USE_EDGEDETECT_FUNCTION 1

vec3 emult = vec3(${strength:2.});

vec3 edgedetect(vec3 origin, vec3 lerped) {
	vec3 diff = abs(origin - lerped);

	vec3 m = pow(vec3(2.), -emult * (diff));
	return lerped * m;
}

