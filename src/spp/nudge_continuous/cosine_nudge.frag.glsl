const float pi = 3.14159265;
float do_cosine_half(float v, float p) {
	float x = (1 - cos(pi * v));
	x = pow(x, p);
	return x;
}
float do_cosine(float v) {
	float r = do_cosine_half(v, 1.);
	return r * sign(v) * 0.5;
}

#define USE_DRIFT_TRANSFORM 1
vec2 transform_drift(vec2 orig) {
	float y =  do_cosine(orig.y);
	return vec2(do_cosine(orig.x), y);
}

#define USE_COLOR_TRANSFORM 1
vec3 transform_color(vec2 relpos, vec3 orig) {
	return orig * (1 - (do_cosine_half(relpos.y, 1.00) * 0.5));
}

