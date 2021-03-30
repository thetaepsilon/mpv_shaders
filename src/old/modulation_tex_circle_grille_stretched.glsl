//!TEXTURE data_circle_grille_stretched
//!SIZE 8 8
//!FORMAT r8
//!FILTER LINEAR
c4f4f4c4c4f4f4c4daffffdadaffffdafafffffafafffffaafffffafafffffaff4c4c4f4f4c4c4f4ffdadaffffdadafffff9f9fffff9f9ffffafafffffafafff

//!HOOK MAINPRESUB
//!DESC modulation texture: hexagon tiled circular grille, stretched
//!BIND HOOKED
//!BIND data_circle_grille_stretched
vec4 hook() {
	const float sx = 8;
	float x = mod(gl_FragCoord.x, sx) / sx;
	const float sy = 8;
	float y = mod(gl_FragCoord.y, sy) / sy;

	float brightness = texture2D(data_circle_grille_stretched, vec2(x, y)).r;
	return HOOKED_tex(HOOKED_pos) * brightness;
}
