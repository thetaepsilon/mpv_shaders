const float scaler = float(${n}) / (float(${n}) - 1.);

vec3 f(vec3 col) {
	#define F(c) ( (( col.c - 1. ) * scaler) + 1. )
	return vec3( F(r), F(g), F(b) );
	#undef F
};
