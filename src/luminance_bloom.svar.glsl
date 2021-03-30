//!HOOK MAINPRESUB
//!BIND ${in}
//!DESC luminance blur, 1/d2 falloff, 2D (WARNING: O(r^2), EXPENSIVE AF)
//!SAVE ${in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h


#define TEXF ${in}_tex
#define SZ ${in}_size
const int radius = ${radius};
const float exposure = ${e:1.0};
const float bias = ${bias:1.0};
const float base_mult = ${bm:1.0};

#define FVEC3(v) (vec3((F(v.r)), (F(v.g)), (F(v.b))))

vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;
	vec3 reference = TEXF(${in}_pos).rgb;

	// note: input assumed rgb only, no alpha channel!
	//vec3 accum = reference;
	vec3 accum = vec3(base_mult * reference);
	vec3 total = vec3(base_mult);

	// vv inb4 coding style triggered
	for (int i = -radius; i <= radius; i++) {
	 for (int j = -radius; j <= radius; j++) {
		vec2 target = inpix + vec2(float(i), float(j));

		// light falloff is 1 / d^2,
		// however d (distance) itself is sqrt(x^2 + y^2),
		// so the square and square root cancel out.
		float d2 = (i * i) + (j * j);
		d2 *= ${dm};
		//d2 = sqrt(d2);
		vec3 weight = vec3(1 / (d2 + bias));

		vec3 c = TEXF(target / SZ).rgb;
		accum += weight * c;
		total += weight;
	 }
	}

	vec3 raw = accum / total;
	vec3 res = raw * exposure;

	// debug A-B viewing mode
	//bool ab = fract(frame / 2.0) < 0.5;
	//if (ab) res = reference;

	#define F(x) (min(x, 1.))
	vec3 clamped = FVEC3(res);
	#undef F
//#optreplace clamped = pow(clamped, vec3(1 / ${postgamma}));
	return vec4(clamped, 1.);
}

