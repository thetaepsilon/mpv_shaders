//!HOOK ${at}
//!DESC channel overshoot (>1.0) detector
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h

vec4 hook() {
	vec4 c = ${in}_tex( ${in}_pos );
	#define DETECT(v) ((c.v > 1.0) ? 1.0 : 0.0)
	vec4 result = vec4( DETECT(r), DETECT(g), DETECT(b), 1.0 );
	#undef DETECT
	return result;
}



