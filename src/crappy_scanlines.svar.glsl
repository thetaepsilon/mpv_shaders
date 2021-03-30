//!HOOK MAINPRESUB
//!DESC poor man's scanline insert
//!BIND HOOKED
//#optreplace //!BIND ${hintbind}
//!WIDTH HOOKED.w
//!HEIGHT HOOKED.h ${h:2} *
//#optreplace #define hint_enable ${hintbind}
//#optreplace #define hint_tex ${hintbind}_tex
const vec2 scale = vec2(1., 1./${h:2}.);
const float hint_mult = ${hm:0.25} ;

vec2 downscale_vec2(vec2 pix) {
	vec2 _i = pix * scale;
	return vec2(floor(_i.x), floor(_i.y)) + vec2(0.5);
}
const int m = ${h:2};
const float dim = ${dim:0.875};
vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;
	vec2 srcpix = downscale_vec2(inpix);
	bool trigger = (int(mod(gl_FragCoord.y, m)) == 0);
	if (trigger) {
		srcpix += vec2(0, -0.5);
	}
	vec2 pos = srcpix / HOOKED_size;
	float s = trigger ? dim : 1.0;
	vec4 data = HOOKED_tex(pos) * s;

	#ifdef hint_enable
	data.rgb += (hint_tex(pos).rgb * hint_mult);
	#endif

	return data;
}

