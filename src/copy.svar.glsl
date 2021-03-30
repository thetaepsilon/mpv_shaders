//!HOOK MAINPRESUB
//!DESC buffer copy: ${in} -> ${out}
//!BIND ${in}
//!SAVE ${out}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h

vec4 hook() {
	return ${in}_tex( ${in}_pos );
}

