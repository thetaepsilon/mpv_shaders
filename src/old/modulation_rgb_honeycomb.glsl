//!TEXTURE data_rgb_honeycomb
//!SIZE 6 4
//!FORMAT rgb8
//!FILTER LINEAR
bbffbbbbffbbffbbbbffbbbbbbbbffbbbbffbbffbbbbffbbffbbbbffbbbbbbbbffbbbbffffbbbbbbbbffbbbbffbbffbbbbffbbffbbbbffbbbbbbbbffbbbbffbbffbbbbffbbffbbbb




//!HOOK MAINPRESUB
//!DESC modulation texture: RGB honeycomb
//!BIND HOOKED
//!BIND data_rgb_honeycomb

//00ff0000ff00ff0000ff00000000ff0000ff00ff0000ff00ff0000ff00000000ff0000ffff00000000ff0000ff00ff0000ff00ff0000ff00000000ff0000ff00ff0000ff00ff0000
//55ff5555ff55ff5555ff55555555ff5555ff55ff5555ff55ff5555ff55555555ff5555ffff55555555ff5555ff55ff5555ff55ff5555ff55555555ff5555ff55ff5555ff55ff5555

vec4 hook() {
	const float sx = 6;
	float x = mod(gl_FragCoord.x, sx) / sx;
	const float sy = 4;
	float y = mod(gl_FragCoord.y, sy) / sy;

	vec4 powers = texture2D(data_rgb_honeycomb, vec2(x, y));
	return HOOKED_tex(HOOKED_pos) * powers;
}
