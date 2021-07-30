float pcos(float x) {
	return (0.5 * cos(x)) + 0.5;
}

float f(float x) {
	float time = float(frame) * 0.0625;
	float xt = pcos(time);
	return mix(1.0, xt, x);
}
