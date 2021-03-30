//!HOOK MAINPRESUB
//!DESC downsampling pass: nearest neighbour
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${w}
//!HEIGHT ${h}
vec4 hook() {
	float x = (gl_FragCoord.x) / float(${w});
	float y = (gl_FragCoord.y) / float(${h});

	float w = MAINPRESUB_size.x;
	float x2 = (floor(x * w) + 0.5) / w;
	float h = MAINPRESUB_size.y;
	float y2 = (floor(y * h) + 0.5) / h;
	vec2 pt = vec2(x2, y2);
	return MAINPRESUB_tex(pt);
}
