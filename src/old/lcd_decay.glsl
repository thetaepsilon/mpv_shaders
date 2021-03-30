//!HOOK OUTPUT
//!BIND OUTPUT
//!DESC memory effect buffer 1
//!WIDTH OUTPUT.w
//!HEIGHT OUTPUT.h
//!SAVE flipbuf1
vec4 hook() {
	if (mod(frame, 2) >= 1) discard;
	return OUTPUT_tex(OUTPUT_pos);
}

//!HOOK OUTPUT
//!BIND OUTPUT
//!DESC memory effect buffer 2
//!WIDTH OUTPUT.w
//!HEIGHT OUTPUT.h
//!SAVE flipbuf2
vec4 hook() {
	if (mod(frame, 2) < 1) discard;
	return OUTPUT_tex(OUTPUT_pos);
}

//!HOOK OUTPUT
//!BIND flipbuf1
//!BIND flipbuf2
//!DESC memory effect overwrite pass
const float ghosting_strength = 0.4;
float decay(float c, float p) {
	float decayed = mix(c, p, 0.75);
	return (c > p) ? c : decayed;
}
vec4 decay_colour(vec4 c, vec4 p) {
	float r = decay(c.r, p.r);
	float g = decay(c.g, p.g);
	float b = decay(c.b, p.b);
	return vec4(r, g, b, 1.);
}
vec4 hook() {
	vec2 pos = flipbuf1_pos;
	vec4 c1 = flipbuf1_tex(pos);
	vec4 c2 = flipbuf2_tex(pos);
	// regardless of what frame starts at (0 or 1),
	// we just need to use the last updated buffer.
	// buf 2 is discarded when frame mod 2 == 0,
	// so we pick buf 1 for 0 mod 2 and buf 2 for 1 mod 2.
	// (ow, that sentence even makes _my_ head hurt >_>).
	// the previous-frame buffer will be decayed from if it was brighter,
	// but if the current buffer is brighter it switches immediately.
	bool flip = (mod(frame, 2) == 1);
	vec4 current  = flip ? c2 : c1;
	vec4 previous = flip ? c1 : c2;
	return decay_colour(current, previous);
}
