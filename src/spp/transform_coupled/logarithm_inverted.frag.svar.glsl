// see below...
const float stops = float(${stops:15});

vec3 f(vec3 c) {
	// inverted logarithmic representation:
	// essentially -log2(c) / stops.
	// this allows us to still work on values in the range 0 .. 1 in the buffer,
	// while making multiplying log values to influence gamma work.
	// float buffers can still represent HDR values (they end up negative)
	// and have no stop limit.

	// first ensure we don't get pesky NaNs everywhere.
	c = max(c, vec3(0.));

	vec3 l = -log2(c);
	const vec3 n = vec3(stops);
	l /= stops;

	return l;
}

vec3 f_undo(vec3 c) {
	const vec3 n = vec3(stops);
	vec3 e = -(c * n);

	vec3 v = pow(vec3(2.), e);
	return v;
}

