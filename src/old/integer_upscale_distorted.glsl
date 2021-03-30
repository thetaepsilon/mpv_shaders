//!HOOK MAINPRESUB
//!DESC integer upscaling pass with sampling distortion
//!BIND HOOKED
//!WIDTH HOOKED.w 2 *
//!HEIGHT HOOKED.h 3 *
#define TEXF HOOKED_tex
#define SZ HOOKED_size
#define HPIXSZ 2
#define VPIXSZ 3
const vec2 scale = vec2(1./float(HPIXSZ), 1./float(VPIXSZ));





#define X(v) (vec2(v, 0.))
#define Y(v) (vec2(0., v))
#define Z (vec2(0.))
#define V(x, y) (vec2(x, y))



/*
// 2x2 light
const vec2 drift_lut[2*2] = vec2[](
	Y(-0.125),	X(0.25),
	X(-0.25),	Y(0.125)
);
*/
/*
// 2x2 fixed 1/3rd horizontal
const vec2 drift_lut[2*2] = vec2[](
	V(-0.33, -0.25),	V(0.33, 0.),
	V(-0.33, 0.),		V(0.33, 0.25)
);
*/
/*
// 2x2 spiky thing
#define D (0.125)
const vec2 drift_lut[2*2] = vec2[](
	Y(-D),	X(D),
	X(-D),	Y(D)
);
#undef D
*/
/*
// 3x3 light
const vec2 drift_lut[3*3] = vec2[](
	V(-0.375, -0.25),	Z,		V(0.25, -0.125),
	X(-0.25),		Z,		X(0.375),
	X(-0.125),		Y(0.25),	V(0.125, 0.125)
);
*/
/*
// 3x3 stronger horizontal
#define M(v) (0.15 * v)
const vec2 drift_lut[3*3] = vec2[](
	X(M(-3)),	Z,	X(M(2)),
	X(M(-2)),	Z,	X(M(3)),
	X(M(-1)),	Z,	X(M(1))
);
#undef M
*/

// 2x3 light
#define M(v) (0.15 * v)
const vec2 drift_lut[2*3] = vec2[](
	V(M(-3), -0.25),	V(M(2), -0.125),
	X(M(-2)),		X(M(3)),
	V(M(-1), 0.25),	V(M(1), 0.125)
);
#undef M

/*
// 2x3 sideways
const vec2 drift_lut[2*3] = vec2[](
	X(-0.375),	X(0.375),
	X(-0.4375),	X(0.50),
	X(-0.50),	X(0.4375)
);
*/
/*
// 2x3 sideways alt
const vec2 drift_lut[2*3] = vec2[](
	X(-0.25),	Y(-0.125),
	X(0),		X(0),
	Y(0.5),	V(0.25, 0.25)
);
*/
/*
// 2x3 fixed 1/3rd horizontal
const vec2 drift_lut[2*3] = vec2[](
	V(-0.33, -0.25),	V(0.33, 0.),
	V(-0.33, 0.),		V(0.33, 0.),
	V(-0.33, 0.),		V(0.33, 0.25)
);
*/
/*
// 2x3 jigsaw
const vec2 drift_lut[2*3] = vec2[](
	X(0),		Y(-0.125),
	X(-0.5),		X(0),
	Y(0.5),	Y(0.25)
);
*/







#undef X
#undef Y
#undef Z
#undef V







vec2 nearest(vec2 pix) {
	return vec2(floor(pix.x), floor(pix.y)) + vec2(0.5);
}

vec4 hook() {

	vec2 inpix = gl_FragCoord.xy;
	vec2 downscaled = inpix * scale;
	vec2 nearest_pix = nearest(downscaled);
	
	int which_x = int(mod(gl_FragCoord.x, float(HPIXSZ)));
	int which_y = int(mod(gl_FragCoord.y, float(VPIXSZ)));
	int idx = (which_y * HPIXSZ) + which_x;
	vec2 drift = drift_lut[idx];

	#ifdef ENABLE_DRIFT_SECONDARY
		drift += drift_secondary[idx];
	#endif

	
	vec2 srcpix = nearest_pix + drift;

	// debug modes below...
	//srcpix = nearest_pix;
	//srcpix = downscaled;
	//srcpix = nearest_pix + unity_drift;

	vec2 pos = srcpix / SZ;
	vec4 data = TEXF(pos);

	return data;
}

