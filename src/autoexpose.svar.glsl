//!HOOK MAINPRESUB
//!DESC adjust linear image exposure based on max brightness
//!BIND ${in}
//!BIND maxbrightness
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h

vec4 hook() {
	vec4 data = ${in}_tex(${in}_pos);
	float br = maxbrightness_tex(vec2(0.5)).r;
	vec4 a = data / br;
	//a = (a * 2) - vec4(1.);
	return a;
}

