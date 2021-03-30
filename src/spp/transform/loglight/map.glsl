float f(float c) {
	// we expect to be working on inputs 0 - 1.
	// log2(0) is -inf, so instead we pick some smallest possible value,
	// and assume all values are at least that.
	// (this technically means true black be impossible,
	// but with any luck nobody will notice if it's really really close.).
	// log2(1.) is 0, so it's a case of at least encoding log2(that tiny value)
	// (which will be negative) to 0 onto the range 0 - 1.
	// the HDR case of >1 needs float bufs anyway,
	// and log2(>1) > 0, so it'll end up >1 when encoded, so this is fine.

	float l = log2(c);
	const float n = ${stops:8.};
	l = max(l, -n);

	// default range of -n to 0, so to shift that into 0 - 1...
	float v = (l + n) / n;

	return v;
}

