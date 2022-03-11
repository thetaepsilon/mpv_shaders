//!HOOK ${after:MAINPRESUB}
//!DESC linear pixel transform pass, rgb only
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h

//#include? function

vec4 hook() {
	vec3 c = ${in}_tex(${in}_pos).rgb;
	bool cond = (${ab_expr:true});
	if (cond) c = ${expr:f(c)};
	return vec4(c, 1.);
}

