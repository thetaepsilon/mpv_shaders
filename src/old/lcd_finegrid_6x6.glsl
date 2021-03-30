//!TEXTURE data_modulation_lcd_rect
//!SIZE 6 6
//!FORMAT rgb8
//!FILTER LINEAR
000000ffffffffffffffffffffffff000000000000ffffffffffffffffffffffff000000000000ffffffffffffffffffffffff000000000000ffffffffffffffffffffffff000000000000ffffffffffffffffffffffff000000000000000000000000000000000000000000


//!HOOK MAINPRESUB
//!DESC LCD transform
//!BIND HOOKED
//!BIND blurdata
//!BIND data_modulation_lcd_rect
//!WIDTH MAINPRESUB.w 6 *
//!HEIGHT MAINPRESUB.h 6 *
#define PIXSZ 6

int pixellate(float v) {
	return int(v / PIXSZ);
}

const float addm = 0.5;
const float exposure = 1.;
vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;
	vec2 modsz = textureSize(data_modulation_lcd_rect, 0);

	float x = pixellate(inpix.x) + 0.5;
	float y = pixellate(inpix.y) + 0.5;

	vec2 pix = vec2(x, y);
	vec4 col = HOOKED_tex(pix / HOOKED_size);


	vec2 mod_sel = vec2(mod(inpix.x, modsz.x), mod(inpix.y, modsz.y)) / modsz;
	vec3 m = texture2D(data_modulation_lcd_rect, mod_sel).rgb;
	col.rgb *= m;

	vec3 addend = blurdata_tex(HOOKED_pos).rgb * addm;
	col.rgb += addend;
	col.rgb *= exposure;

	return col;
}
