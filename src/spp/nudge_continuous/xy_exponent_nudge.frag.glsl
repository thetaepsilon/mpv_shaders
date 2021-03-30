
const vec2 exponent = vec2(${ex}, ${ey});
// when raising a value that is 0 - 0.5 to some exponent,
// it will end up in the range 0 - (0.5 ^ x).
// in order to get back into the 0.5 range like we want,
// we can first divide by 0.5 ^ x, which is equivalent to * 0.5 ^ (-x),
// then multiply by 0.5, resulting in a scale correction value of 0.5 ^ ((-x) + 1).
#define FACTOR(x) (pow( 0.5, ((-(x)) + 1) ))
const vec2 rescale = vec2( FACTOR(${ex}), FACTOR(${ey}) );


#define USE_DRIFT_TRANSFORM 1
vec2 transform_drift(vec2 orig) {
	vec2 signs = vec2(sign(orig.x), sign(orig.y));
	vec2 av = abs(orig);
	vec2 raised = pow(av, exponent);
	vec2 scaled = raised * rescale * signs;
	return scaled;
}

