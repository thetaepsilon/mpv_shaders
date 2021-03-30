//!HOOK MAINPRESUB
//!DESC custom stretch ratio kernel
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h 3 * 2 /

#define STRETCH_Y 3
#define SPAN_SRC_Y 2


#define MV 0.65625
const float nudge[] = float[](
	-0.5,	0.0,	0.5
);
const float intensity[] = float[](
	1.0,	MV,	1.0
);


vec4 hook() {
	vec2 pix = gl_FragCoord.xy;
	float m = 1.0;

	#ifdef STRETCH_Y
	float cy = (floor(pix.y / STRETCH_Y) + 0.5) * SPAN_SRC_Y;
	int idx = int(mod(pix.y, STRETCH_Y));
	float ry = cy + nudge[idx];
	pix.y = ry;
	m *= intensity[idx];
	#endif

	vec2 pt = pix / ${in}_size;
	return ${in}_tex(pt) * m;
}

