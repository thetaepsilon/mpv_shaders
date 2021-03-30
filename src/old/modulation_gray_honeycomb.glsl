//!TEXTURE data_mono_honeycomb
//!SIZE 6 4
//!FORMAT r8
//!FILTER LINEAR
ffffccccaaaaffffccccaaaaccaaaaffffccccaaaaffffcc




//!HOOK MAINPRESUB
//!DESC modulation texture: RGB honeycomb
//!BIND HOOKED
//!BIND data_mono_honeycomb

vec4 hook() {
	vec2 sel = gl_FragCoord.xy;

	const float sx = 6;
	float x = mod(sel.x, sx) / sx;
	const float sy = 4;
	float y = mod(sel.y, sy) / sy;

	vec2 hpt = vec2(x, y);
	float power = texture2D(data_mono_honeycomb, hpt).r;
	//power = power * power;
	return HOOKED_tex(HOOKED_pos) * power;
}
