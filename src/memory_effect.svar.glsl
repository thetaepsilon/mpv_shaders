//!HOOK ${at:MAINPRESUB}
//!BIND ${in}
//!DESC memory effect buffer 1
//!WIDTH ${in}.w
//!HEIGHT ${in}.h
//!SAVE flipbuf1
vec4 hook() {
	if (mod(float(frame), 2.0) >= 1.0) discard;
	return ${in}_tex(${in}_pos);
}

//!HOOK ${at:MAINPRESUB}
//!BIND ${in}
//!DESC memory effect buffer 2
//!WIDTH ${in}.w
//!HEIGHT ${in}.h
//!SAVE flipbuf2
vec4 hook() {
	if (mod(float(frame), 2.0) < 1.0) discard;
	return ${in}_tex(${in}_pos);
}

//!HOOK ${at:MAINPRESUB}
//!BIND flipbuf1
//!BIND flipbuf2
//!DESC memory effect overwrite pass
//!WIDTH ${in}.w
//!HEIGHT ${in}.h
//!SAVE ${in}
const float ghosting_strength = 0.5;
vec4 hook() {
	vec2 pos = flipbuf1_pos;
	vec4 c1 = flipbuf1_tex(pos);
	vec4 c2 = flipbuf2_tex(pos);
	// regardless of what frame starts at (0 or 1),
	// we just need to use the last updated buffer.
	// buf 2 is discarded when frame mod 2 == 0,
	// so we pick buf 1 for 0 mod 2 and buf 2 for 1 mod 2.
	// (ow, that sentence even makes _my_ head hurt >_>).
	// the "losing" buffer gets down-weighted to 0.25 of the total MAINPRESUB.
	// note it's seemingly backwards below as in the mix(), 0.0 means all c1.
	float pick = ( int(mod(float(frame), 2.0)) == 0) ? ghosting_strength : (1. - ghosting_strength);
	return mix(c1, c2, pick);
}
