//!HOOK MAINPRESUB
//!DESC pre-downsample pass for blurring
//!BIND HOOKED
//!SAVE blurdata
//!WIDTH HOOKED.w 16 /
//!HEIGHT HOOKED.h 16 /
// note: be sure to get these in the right order if they are not equal!
#define MAP_X 16
#define MAP_Y 16
// total number of samples, reciprocal to scale total to average.
const float scale = 1.0 / (MAP_X * MAP_Y);
vec4 hook() {
	int tx = int(gl_FragCoord.x);
	int ty = int(gl_FragCoord.y);

	int ox = tx * MAP_X;
	int oy = ty * MAP_Y;
	vec4 total = vec4(0.);
	for (int x = 0; x < MAP_X; x++) {
	for (int y = 0; y < MAP_Y; y++) {
		vec2 srcpix = vec2(ox + x, oy + y);
		vec2 srcpt = srcpix / HOOKED_size;
		vec4 data = HOOKED_tex(srcpt);
		total += data;
	}
	}
	return total * scale;
}


//!HOOK MAINPRESUB
//!BIND blurdata
//!DESC box blur stage 1
//!SAVE blurdata
//!WIDTH blurdata.w
//!HEIGHT blurdata.h
#define SZ blurdata_size
#define TEXF blurdata_tex
vec4 hook() {
	float ox = gl_FragCoord.x;
	float oy = gl_FragCoord.y;

	vec4 total = vec4(0.);
	for (int x = -1; x <= 1; x++) {
	for (int y = -1; y <= 1; y++) {
		vec2 srcpix = vec2(ox + x, oy + y);
		vec2 srcpt = srcpix / SZ;
		vec4 data = TEXF(srcpt);
		total += data;
	}
	}
	return total / 9.;
}



//!HOOK MAINPRESUB
//!BIND blurdata
//!DESC box blur stage 2
//!SAVE blurdata
//!WIDTH blurdata.w
//!HEIGHT blurdata.h
#define SZ blurdata_size
#define TEXF blurdata_tex
vec4 hook() {
	float ox = gl_FragCoord.x;
	float oy = gl_FragCoord.y;

	vec4 total = vec4(0.);
	for (int x = -1; x <= 1; x++) {
	for (int y = -1; y <= 1; y++) {
		vec2 srcpix = vec2(ox + x, oy + y);
		vec2 srcpt = srcpix / SZ;
		vec4 data = TEXF(srcpt);
		total += data;
	}
	}
	return total / 9.;
}



//!HOOK MAINPRESUB
//!BIND blurdata
//!DESC box blur stage 3
//!SAVE blurdata
//!WIDTH blurdata.w
//!HEIGHT blurdata.h
#define SZ blurdata_size
#define TEXF blurdata_tex
vec4 hook() {
	float ox = gl_FragCoord.x;
	float oy = gl_FragCoord.y;

	vec4 total = vec4(0.);
	for (int x = -1; x <= 1; x++) {
	for (int y = -1; y <= 1; y++) {
		vec2 srcpix = vec2(ox + x, oy + y);
		vec2 srcpt = srcpix / SZ;
		vec4 data = TEXF(srcpt);
		total += data;
	}
	}
	return total / 9.;
}



//!HOOK MAINPRESUB
//!BIND blurdata
//!DESC box blur stage 4
//!SAVE blurdata
//!WIDTH blurdata.w
//!HEIGHT blurdata.h
#define SZ blurdata_size
#define TEXF blurdata_tex
vec4 hook() {
	float ox = gl_FragCoord.x;
	float oy = gl_FragCoord.y;

	vec4 total = vec4(0.);
	for (int x = -1; x <= 1; x++) {
	for (int y = -1; y <= 1; y++) {
		vec2 srcpix = vec2(ox + x, oy + y);
		vec2 srcpt = srcpix / SZ;
		vec4 data = TEXF(srcpt);
		total += data;
	}
	}
	return total / 9.;
}



//!HOOK MAINPRESUB
//!BIND blurdata
//!DESC box blur stage 5
//!SAVE blurdata
//!WIDTH blurdata.w
//!HEIGHT blurdata.h
#define SZ blurdata_size
#define TEXF blurdata_tex
vec4 hook() {
	float ox = gl_FragCoord.x;
	float oy = gl_FragCoord.y;

	vec4 total = vec4(0.);
	for (int x = -1; x <= 1; x++) {
	for (int y = -1; y <= 1; y++) {
		vec2 srcpix = vec2(ox + x, oy + y);
		vec2 srcpt = srcpix / SZ;
		vec4 data = TEXF(srcpt);
		total += data;
	}
	}
	return total / 9.;
}




//!HOOK MAINPRESUB
//!BIND HOOKED
//!BIND blurdata
//!DESC bloom using additive box blur
#define FVEC3(v) (vec3((F(v.r)), (F(v.g)), (F(v.b))))
vec4 hook() {
	vec3 reference = HOOKED_tex(HOOKED_pos).rgb;
	vec3 addend = blurdata_tex(HOOKED_pos).rgb * 1.0;

	bool ab = fract(frame / 2.0) < 0.5;
	vec3 result = (reference + addend);
	//if (ab) {
	//	result = addend;
	//}
	result *= 0.675;
	

	// ensure the result doesn't blare out - some shader passes don't like this
	#define F(x) (min(x, 1.0))
	result = FVEC3(result);
	#undef F

	//result = result - reference;
	//result = addend;

	return vec4(result, 1.);
}



