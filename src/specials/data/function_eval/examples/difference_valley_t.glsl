float pcos(float x) {
	return (0.5 * cos(x)) + 0.5;
}

float pi = radians(180.0);

float fn(float x, float n) {
	return pcos(x * pi * 2.0) * n;
}

float f(float x) {
	float time = float(frame) * 0.0625;
	float xt = pcos(time);

	float y1 = 1.0;
	float y2 = xt;

	float f1 = fn(x, y1);
	float f2 = fn(x, y2);

	float m = (0.5 * (sign(x - 0.5))) + 0.5;

	return mix(f1, f2, m);
}
