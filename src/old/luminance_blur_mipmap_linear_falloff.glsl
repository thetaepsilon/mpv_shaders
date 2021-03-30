//!HOOK MAINPRESUB
//!BIND HOOKED
//!DESC luminance weighted blur, 1/d2, mipmap level 1
//!SAVE light_mipmap_lvl1
//!WIDTH HOOKED.w 2 /
//!HEIGHT HOOKED.h 2 /
// XXX: this is a lot of code duplication for each mipmap pass,
// but mpv splits this file up at each HOOK block, so we have no choice atm.
/*
#define SZ 2
vec4 hook() {
	int tx = int(gl_FragCoord.x);
	int ty = int(gl_FragCoord.y);

	int ox = tx * SZ;
	int oy = ty * SZ;
	vec4 total = vec4(0.);
	for (int x = 0; x < SZ; x++) {
	for (int y = 0; y < SZ; y++) {
		vec2 srcpix = vec2(ox + x, oy + y);
		vec2 srcpt = srcpix / HOOKED_size;
		vec4 data = HOOKED_tex(srcpt);
		total += data;
	}
	}
	// in theory mpv sometimes gives us float buffers (can go above 1.0),
	// but I'd rather not rely on it.
	// besides, the precision becomes less essential far away from a light source.
	return total / (SZ * SZ);
}
*/
vec4 hook() {
	int tx = int(gl_FragCoord.x);
	int ty = int(gl_FragCoord.y);

	int ox = tx * 2;
	int oy = ty * 2;
	/*
	vec2 pix;
	pix = vec2(ox + 0, oy + 0);
	vec4 d1 = HOOKED_tex(pix / HOOKED_size);
	pix = vec2(ox + 1, oy + 0);
	vec4 d2 = HOOKED_tex(pix / HOOKED_size);
	pix = vec2(ox + 0, oy + 1);
	vec4 d3 = HOOKED_tex(pix / HOOKED_size);
	pix = vec2(ox + 1, oy + 1);
	vec4 d4 = HOOKED_tex(pix / HOOKED_size);
	*/
	#define SAMPLE(name, ax, ay) \
		vec4 name = HOOKED_tex(vec2(ox + ax, oy + ay) / HOOKED_size);
	SAMPLE(d1, 0, 0);
	SAMPLE(d2, 1, 0);
	SAMPLE(d3, 0, 1);
	SAMPLE(d4, 1, 1);
	#undef SAMPLE

	#define MAX(C) float C = ( max( max( d1.C , d2.C), max( d3.C , d4.C )) )
	MAX(r);
	MAX(g);
	MAX(b);
	// problem no.1 with macros: no lexical scope.
	#undef MAX
	return vec4(r, g, b, 1.0);
}



//!HOOK MAINPRESUB
//!BIND light_mipmap_lvl1
//!DESC luminance weighted blur, 1/d2, mipmap level 2
//!SAVE light_mipmap_lvl2
//!WIDTH light_mipmap_lvl1.w 2 /
//!HEIGHT light_mipmap_lvl1.h 2 /
vec4 hook() {
	int tx = int(gl_FragCoord.x);
	int ty = int(gl_FragCoord.y);

	int ox = tx * 2;
	int oy = ty * 2;

	#define SAMPLE(name, ax, ay) \
		vec4 name = light_mipmap_lvl1_tex(vec2(ox + ax, oy + ay) / light_mipmap_lvl1_size);
	SAMPLE(d1, 0, 0);
	SAMPLE(d2, 1, 0);
	SAMPLE(d3, 0, 1);
	SAMPLE(d4, 1, 1);
	#undef SAMPLE

	#define MAX(C) float C = ( max( max( d1.C , d2.C), max( d3.C , d4.C )) )
	MAX(r);
	MAX(g);
	MAX(b);
	#undef MAX
	return vec4(r, g, b, 1.0);
}




//!HOOK MAINPRESUB
//!BIND HOOKED
//!BIND light_mipmap_lvl1
//!BIND light_mipmap_lvl2
//!DESC luminance weighted blur, 1/d2, mipmapped, calculation phase
#define RADIUS 2
//const int i = 0;
#define FVEC3(v) (vec3((F(v.r)), (F(v.g)), (F(v.b))))
#define F2VEC3(v1, v2) (vec3(F2(v1.r, v2.r), F2(v1.g, v2.g), F2(v1.b, v2.b)))
#define BPOW 1.5
// X-macro time, on account of not having a better (inline) way of doing this.
// well, technically it's the P-macro here; X would be confusing with coordinates.
// this is the ring of eight samples about the centre for each level of mipmap.
// the centre itself is omitted, as there would either be the previous mipmap level,
// or for the innermost ring it would be the reference pixel itself.
#define DO_POSITIONS \
	P(-1, 1)	P(0, 1)	P(1, 1) \
	P(-1, 0)	/*P(0, 0)*/	P(1, 0) \
	P(-1, -1)	P(0, -1)	P(1, -1)

vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;
	vec3 reference = HOOKED_tex(HOOKED_pos).rgb;
	bool ab = fract(frame / 2.0) < 0.5;

	// note: input assumed rgb only, no alpha channel!
	vec3 accum = reference;
	vec3 total = vec3(1.0);

	// nested functions would make things so much easier.
	//#define F(x) pow(x, 0.5)
	#define P1(x, y, s, m, texf) {\
		int i = x * s; \
		int j = y * s; \
		vec2 target = inpix + vec2(float(i) + 0.5, float(j) + 0.5); \
		float d = sqrt((i * i) + (j * j)) * 1.; \
		vec3 weight = vec3(1 / (d + 1)); \
		vec2 pt = target / HOOKED_size; \
		vec3 c = ( texf (pt)).rgb * m; \
		vec3 result = weight * c; \
		accum += result; \
		total += weight; \
	}
		// total += result;
		// total += weight;
	#define P(x, y) P1(x, y, 1, 1, HOOKED_tex)
	DO_POSITIONS
	#undef P

	#define P(x, y) P1(x, y, 2, 4, light_mipmap_lvl1_tex)
	DO_POSITIONS
	#undef P
	
	#define P(x, y) P1(x, y, 4, 16, light_mipmap_lvl2_tex)
	//if (ab) {
		DO_POSITIONS
	//}
	#undef P

	vec3 raw = accum / total;
	vec3 res = raw * 0.13;
	//vec3 res = (accum * 3) / 256;
	//if (ab) {
		#define F2(x, y) max(x, y)
		// ensure the result can never be darker than the original invoking pixel.
		// this ensures that we don't end just being a isotropic blur if something balls up.
		res = F2VEC3(res, reference);
		#undef F2
	//}
	vec3 diff = res - reference;
	// at this point we know that (per channel) result must be equal or greater than reference,
	// therefore diff will be strictly positive.
	// enhance the effect a bit by adding another fraction of that amount again.
	//res += diff * 0.7;
	
	// debug A-B viewing mode
	//if (ab) res = reference;

	// debug mode: show just the light that would be added. (looks kinda like edge detection!)
	//res = diff * 2;

	#define F(x) (min(x, 1.))
	vec3 clamped = FVEC3(res);
	#undef F
	return vec4(clamped, 1.);
}



/*
	for (int x = -RADIUS; x <= RADIUS; x++) {
		for (int y = -RADIUS; y <= RADIUS; y++) {
			int i = x * 2;
			int j = y * 2;
			//const int j = 0;
			// I'ma be honest here, I don't know why I need the +0.5's.
			// but it fixes a misalignment of the mipmapped image, so...
			// ¯\_(ツ)_/¯
			vec2 target = inpix + vec2(float(i) + 0.5, float(j) + 0.5);
			// light falloff is 1 / d^2,
			// however d (distance) itself is sqrt(x^2 + y^2),
			// so the square and square root cancel out.
			float d2 = (i * i) + (j * j);
			//float d2 = (i * i) * (j * j);
			d2 *= 1;
			vec3 weight = vec3(1 / (d2 + 1));
			vec2 pt = target / HOOKED_size;
			vec3 c = light_mipmap_lvl1_tex(pt).rgb;
			
			#define F(x) pow(x, 0.5)
			//weight *= FVEC3(c);
			#undef F
			accum += weight * c;
			total += weight;
		}
	}
*/




