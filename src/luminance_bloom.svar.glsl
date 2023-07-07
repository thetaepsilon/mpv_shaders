//!HOOK ${at:LINEAR}
//!BIND ${in}
//!DESC luminance blur, 1/d2 falloff, 2D (WARNING: O(r^2), EXPENSIVE AF)
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h


#define TEXF ${in}_tex
#define SZ ${in}_size

const int radius = ${radius};
const float radius_f = float(radius);

const float dm = float(${distance_scale:1.});
const float dm2 = dm * dm;

const float d2limit = radius_f * radius_f;

// prevents divide by zeroes, has the effect of making sources end up more diffused if increased.
const float bias = ${bias:0.001};



float distance_squared(vec2 p) {
	// light falloff is 1 / d^2,
	// however d (distance) itself is sqrt(x^2 + y^2),
	// so the square and square root cancel out;
	// therefore we can work in squared distance and drop the sqrt.
	// thus we just want (x^2 + y^2).

	vec2 p2 = p * p;	// vec2(x * x, y * y)

	float d2 = p2.x + p2.y;
	return d2;
}



vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;

//#optreplace #if ${load_reference}
//#optreplace vec3 reference = TEXF(${in}_pos).rgb;	// load_reference = ${load_reference}
//#optreplace #endif	// load_reference = ${load_reference}

	vec3 accum = vec3(0.);
	float weight_total = 0.;

	for (int i = -radius; i <= radius; i++) {
	  for (int j = -radius; j <= radius; j++) {
		vec2 offset = vec2(float(i), float(j));
		vec2 target = inpix + offset;

		float d2 = distance_squared(offset);
		bool inside = (d2 <= d2limit);

		if (inside) {
			// commutivity: (distance * dm) * (distance * dm)
			// (and we need a (scaled) distance squared for inverse square falloff)
			// we already have distance squared, so...
			float scaled_d2 = d2 * dm2;
			float weight = 1. / (scaled_d2 + bias);

			vec3 c = TEXF(target / SZ).rgb;
			accum += weight * c;
			weight_total += weight;
		}
	  }
	}

	vec3 result = accum / vec3(weight_total);

//#optreplace result = ${output_transform};

	return vec4(result, 0.);
}

