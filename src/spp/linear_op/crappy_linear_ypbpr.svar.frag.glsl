
const float _kr = 0.3125;
const float _kg = 0.375;
const float _kb = 0.3125;


/*
const float _kr = 4. / 16.;
const float _kg = 8. / 16.;
const float _kb = 4. / 16.;
*/

const vec3 _kdot = vec3(_kr, _kg, _kb);

const float _kb_m = 1.0 - _kb;
const float _kr_m = 1.0 - _kr;



float _ypbpr_sign_gamma(float x, float p) {
	float v = abs(x);
	float s = sign(x);
	return pow(v, p) * s;
}



const float _ypbpr_c_gamma = 1.1;
const float _ypbpr_c_gamma_undo = 1.0 / _ypbpr_c_gamma;



vec3 f(vec3 c) {

	float y = dot(c, _kdot);

//#define DO(ch) float p ## ch = 0.5 * (c.ch - y) / _k ## ch ## _m
#define DO(ch) \
	float p ## ch = (c.ch - y); \
	float ch ## prime = _ypbpr_sign_gamma( p ## ch , _ypbpr_c_gamma);

	DO(r)
	DO(b)
#undef DO


	// beware ordering elsewhere
	// y - 0.5
	return vec3(rprime, y, bprime);
}


vec3 f_undo(vec3 c) {
	float y = c.y; // + 0.5;
	float cr = _ypbpr_sign_gamma(c.r, _ypbpr_c_gamma_undo);
	float cb = _ypbpr_sign_gamma(c.b, _ypbpr_c_gamma_undo);


	float r = cr + y;
	float b = cb + y;

	float gprime = y;
	gprime -= r * _kr;
	gprime -= b * _kb;
	float g = gprime / _kg;


	vec3 cprime = vec3(r, g, b);
	return cprime;
}




