//!HOOK ${after:MAINPRESUB}
//!DESC solid white buffer debug
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h

vec4 hook() {
	return vec4(1.);
}
