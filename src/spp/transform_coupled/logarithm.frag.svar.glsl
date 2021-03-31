// see below...
const float stops = float(${stops:16});

vec3 f(vec3 c) {
	// we expect to be working on inputs 0 - 1.
	// log2(0) is -inf, so instead we pick some smallest possible value,
	// and assume all values are at least that.
	// (this technically means true black be impossible,
	// but with any luck nobody will notice if it's really really close.).
	// log2(1.) is 0, so it's a case of at least encoding log2(that tiny value)
	// (which will be negative) to 0 onto the range 0 - 1.
	// the HDR case of >1 needs float bufs anyway,
	// and log2(>1) > 0, so it'll end up >1 when encoded, so this is fine.

	// in theory one could just leave the float representation as-is,
	// but a) -inf black tends to dominate in log-space interpolation,
	// and b) it's not very amenable to potential future use of integer intermediate buffers
	// (even if the above rescaling was implicit there's just no way to encode +-inf).

	// initial preconditioning: make sure the input is at least zero
	// (dang video decoding returning negative overshoot values!),
	// as any negatives are gonna throw a huge spanner in the form of NaNs everywhere.
	c = max(c, vec3(0.));

	vec3 l = log2(c);
	const vec3 n = vec3(stops);
	l = max(l, -n);
	// no HDR, sorry. it slightly breaks the idea of scaling logarithm values to influence gamma,
	// and would be out of range anyway in this representation.
	l = min(l, 0.);

	// above value is in range of -n to 0, so to shift that into 0 - 1,
	// we add n to be 0 to n, then divide by n to get 0 to 1.
	vec3 v = (l + n) / n;

	return v;
}

vec3 f_undo(vec3 c) {
	// note: this value must be kept in sync with the original presel stage!
	const vec3 n = vec3(stops);
	vec3 e = (c * n) - n;

	vec3 v = pow(vec3(2.), e);
	return v;
}

