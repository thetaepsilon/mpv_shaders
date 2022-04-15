//!HOOK ${at}
//!DESC channel overshoot (>1.0) detector
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h

vec4 hook() {
	vec4 c = ${in}_tex( ${in}_pos );
	bvec4 overshoot = greaterThan(c, vec4(1.));
	return vec4(overshoot);
}



