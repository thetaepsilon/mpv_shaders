const float lt_epsilon = -1. / 1024.;

float f_undo(float c) {
	// note: this value must be kept in sync with the original presel stage!
	const float n = ${stops:8.};
	const float e = (c * n) - n;
	if ((e - lt_epsilon) < -n) return 0.;
	const float v = pow(2, e);
	return v;
}
