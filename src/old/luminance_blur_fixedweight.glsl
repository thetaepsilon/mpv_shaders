//!HOOK MAINPRESUB
//!BIND HOOKED
//!DESC luminance weighted blur, inverse square, fixed average
#define RADIUS 8
//const int i = 0;
#define FVEC3(v) (vec3((F(v.r)), (F(v.g)), (F(v.b))))
#define F2VEC3(v1, v2) (vec3(F2(v1.r, v2.r), F2(v1.g, v2.g), F2(v1.b, v2.b)))
vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;
	//vec4 reference = HOOKED_tex(HOOKED_pos);
	
	// note: input assumed rgb only, no alpha channel!
	//vec3 reference = HOOKED_tex(inpix / HOOKED_size).rgb;
	vec3 accum = vec3(0.);
	for (int i = -RADIUS; i <= RADIUS; i++) {
		for (int j = -RADIUS; j <= RADIUS; j++) {
			//const int j = 0;
			vec2 target = inpix + vec2(float(i), float(j));
			// light falloff is 1 / d^2,
			// however d (distance) itself is sqrt(x^2 + y^2),
			// so the square and square root cancel out.
			float d2 = (i * i) + (j * j);
			//float d2 = i + j;
			d2 *= 5.;
			// note that we have to have some sort of min distance here,
			// or else light at a singularity goes to infinity!
			float w = 1 / max(d2, 1.);
			vec3 weight = vec3(w);
			vec3 c = HOOKED_tex(target / HOOKED_size).rgb;
			#define F(x) pow(x, 1.5)
			//c = FVEC3(c);
			#undef F
			accum += weight * c;
		}
	}
	vec3 res = accum * 4.;

	//vec3 res = (accum + reference) * 0.8;
	// clamping necessary here, as mpv's internal intermediate buffers can be floats,
	// and these values can go above 1.0 in theory!
	// this however could be great for either a HDR display or high contrast displays like OLED
	// (for the latter, turn the multiplier down on the vec3 res line).
	#define F(x) (min(x, 1.))
	vec3 clamped = FVEC3(res);
	#undef F
	//if (fract(frame / 2.0) < 0.5) return reference;
	return vec4(clamped, 1.);
}

