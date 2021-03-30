//!HOOK ${after:MAINPRESUB}
//!DESC zero data debug
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h

vec4 hook() {
	return vec4(0.);
}
