//!HOOK ${after:MAINPRESUB}
//!DESC fixed bilinear scaling, ${x}x${y:$x}
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in}.w ${x} *
//!HEIGHT ${in}.h ${y:$x} *

vec4 hook() {
	return ${in}_tex(${in}_pos);
}

