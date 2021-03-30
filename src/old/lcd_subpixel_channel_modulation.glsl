//!HOOK MAINPRESUB
//!DESC lcd subpixel brightness-only modulation
//!BIND HOOKED
//!WIDTH HOOKED.w 3 *
//!HEIGHT HOOKED.h 3 *
#define ROW_DIM 0.8
#define PHEIGHT 3
float pixv(float outpix, float res, float div) {
	return (floor(outpix / div) + 0.5) / res;
}
vec2 pt_for(vec2 outpix) {
	float u = pixv(outpix.x, HOOKED_size.x, 3);
	float v = pixv(outpix.y, HOOKED_size.y, PHEIGHT);
	return vec2(u, v);
}
//const float lut[] = float[](1.0, 0.65, 0.165);
//const float lut[] = float[](1.0, 0.67, 0.4444444);
//const float lut[] = float[](1.0, 0.7, 0.49);
const float lut[] = float[](1.0, 0.8, 0.5);
#define FVEC3(v) (vec3((F(v.r)), (F(v.g)), (F(v.b))))
#define F2VEC3(v1, v2)  ( vec3( F2(v1.r, v2.r), F2(v1.g, v2.g), F2(v1.b, v2.b) ) )
vec4 hook() {
	vec2 srcpt = pt_for(gl_FragCoord.xy);
	vec4 col = HOOKED_tex(srcpt);

	int which = int(mod(int(gl_FragCoord.x), 3));
	//float lut[] = float[](1.0, 0., 0.);
	// due to subpixel ordering on the _real_ display (RGB at time of writing),
	// bright blue channel screws with the effect somewhat.
	// so dip the second simulated subpixel further to avoid blockiness showing up when that happens.
	//lut[1] = pow(0.667, p) - (0.11 * col.b);
	//lut[2] = pow(.44444, p) - (0.11 * col.b);
	//lut[1] = 0.9375 - (0.125 * col.b);
	//lut[2] = 0.875 - (0.125 * col.b);

	// further fuckery: 6-bit panel problems.
	// a straight multiply isn't gonna cut it at low channel values,
	// as everything becomes AFuckenMess (sorry, sysghost ;) ).
	// we can still work multiplicatively to start with,
	// but then we must force that x1 > x2 > x3 *on the actual display*,
	// and to do that they must be at least minimum_dip apart (set it below).
	const float minimum_dip = 8. / 255.;	// adjust for your screen shenanigans
	const vec3 adj = vec3(-minimum_dip);
	const vec3 adj2 = vec3(-2 * minimum_dip);

	// now it gets a bit tricky.
	// we're assuming that each channel is dimmable in the same increment for now.
	// we basically need to work out the output colours for all three virtual subpixels at once
	// (XXX: can this be optimised with an extra pass?),
	// then enforce the above discussed constraints on them on a per-channel basis.
	#define E(x) (col.rgb * lut[x])
	vec3 subpixels[] = vec3[](E(0), E(1), E(2));
	#undef E
	#define F2(x, y) (min(x, y))
	vec3 s0 = subpixels[0] + adj;
	subpixels[1] = F2VEC3(s0, subpixels[1]);
	vec3 s1 = subpixels[1] + adj;
	subpixels[2] = F2VEC3(s1, subpixels[2]);
	#undef F2

	
	//vec3 element = col.rgb - vec3(lut[which] * minimum_dip);	
	//vec3 element = vec3(0.5);
	vec3 element = subpixels[which];

	// dim the first row a bit where many TFT LCDs have their transistor banks.
	// also note, we must force the above constraint yet again for this to not look blocky sometimes.
	//const vec3 adj3 = vec3(-3 * minimum_dip);
	bool dim_row = (mod(gl_FragCoord.y, PHEIGHT) < 1.);
	vec3 wanted_c = element * ROW_DIM;
	vec3 c = element;
	if (dim_row) {
		#define F2(x, y) (min(x, y))
		vec3 row_dim_min = element + adj2;
		c = F2VEC3(row_dim_min, wanted_c);
		#undef F2
	}
	

	return vec4(c, 1.0);
}


/*
	// transform the colour to undo the impact the below has (gamma fuckery)
	#define ALTER(c) col.c = sqrt(col.c)
	//ALTER(r);
	//ALTER(g);
	//ALTER(b);

	// depending on which subpixel we are, we select the appropriate colour channel.
	#define PICK(chan, index) float chan = ((which == index) ? col.chan : 0.)
	PICK(r, 0);
	PICK(g, 1);
	PICK(b, 2);
	float activation = r + g + b;
	vec3 element = col.rgb * activation;
*/

