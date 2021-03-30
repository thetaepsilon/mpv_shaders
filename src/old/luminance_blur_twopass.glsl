//!HOOK MAINPRESUB
//!BIND HOOKED
//!DESC luminance weighted box blur, horizontal pass
#define RADIUS 60
const float e = 2.;
float f(float i) { return i * i; }
vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;

	// note: input assumed rgb only, no alpha channel!
	vec3 accum = vec3(0.);
	vec3 total = vec3(0.5);
	for (int i = -RADIUS; i <= RADIUS; i++) {
		vec2 target = inpix + vec2(float(i), 0);
		/*
		float d2 = min(abs(i) * 0.25, PI2);
		float w = cos(d2);
		vec3 weight = vec3(w * w * w);
		*/
		float d2 = f(abs(i));
		//float d2 = abs(i);
		//d2 *= 2.;
		vec3 weight = vec3(1 / (1 + d2));
		vec3 c = HOOKED_tex(target / HOOKED_size).rgb;

		accum += weight * c;
		total += weight;
	}
	//vec3 r = (accum * e) / total;
	vec3 r = accum;
	return vec4(r, 1.);
}

//!HOOK MAINPRESUB
//!BIND HOOKED
//!DESC luminance weighted box blur, horizontal pass
const float e = 2.;
#define RADIUS 60
float f(float i) { return i * i; }
vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;

	// note: input assumed rgb only, no alpha channel!
	vec3 accum = vec3(0.);
	vec3 total = vec3(0.5);
	for (int i = -RADIUS; i <= RADIUS; i++) {
		vec2 target = inpix + vec2(0, float(i));
		/*
		float d2 = min(abs(i) * 0.25, PI2);
		float w = cos(d2);
		vec3 weight = vec3(w * w * w);
		*/
		float d2 = f(abs(i));
		//float d2 = abs(i);
		//d2 *= 2.;
		vec3 weight = vec3(1 / (1 + d2));
		vec3 c = HOOKED_tex(target / HOOKED_size).rgb;

		accum += weight * c;
		total += weight;
	}
	//vec3 r = (accum * e) / total;
	vec3 r = accum;
	return vec4(r, 1.);
}
