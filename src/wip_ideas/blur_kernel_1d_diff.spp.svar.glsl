//!HOOK ${after:MAINPRESUB}
//!DESC blur kernel, 1D (configurable direction), with difference falloff
//!BIND ${in}
//!SAVE ${out:$in}
//!COMPONENTS 3

//#include kernel



#define TEXF ${in}_tex
#define SZ  ( ${in}_size )

const int xs = ${xs:0};
const int ys = ${ys:0};

const vec3 output_scale = vec3(${e:1.0});
const vec2 stepv = vec2(float(xs), float(ys));

vec4 read(vec2 pix) {
	vec2 pt = pix / SZ;
	vec4 data = TEXF(pt);


	return data;
}

const vec3 zero = vec3(0.0);
const vec3 unity = vec3(1.0);

bool outofbounds(vec2 pt) {
	bvec2 gt =	greaterThan(pt, vec2(1.0));
	bvec2 lt =	lessThan(pt, vec2(0.0));
	return any(gt) && any(lt);
}



vec3 collect(vec2 origin, vec3 initial, int sgn) {
	vec3 total = zero;
	vec3 mult = vec3(1.0);
	vec3 last = initial;

	for (int i = sgn; sgn * i <= kernel_radius; i += sgn) {

		vec2 pix = origin + (vec2(i) * stepv);
		vec4 data = read(pix);

		int idx = i + kernel_radius;
		float m = kernel_data[idx];

		float significance = data.a;
		vec3 current = data.rgb;
		vec3 diff = pow(abs(current - last), vec3(${diffpow:1.0})) * significance * vec3(${dampening:1.0});
		vec3 attenuate = vec3(1.0) - diff;
		attenuate = clamp(attenuate, zero, unity);
		mult *= attenuate;

		vec3 contrib = current * m * mult;
		last = current;
		total += contrib;
	}

	return total;
}


vec4 hook() {
	vec2 origin = gl_FragCoord.xy;
	if (outofbounds(origin / SZ)) discard;
	vec3 total = vec3(0.);

	// alpha channel significance ignored for the starting point...
	vec4 centre = read(origin);
	total += centre.rgb;
	vec3 initial = centre.rgb;

	total += collect(origin, initial, -1);
	total += collect(origin, initial,  1);

	#ifdef KERNEL_SCALE_VALUE
	total *= ( KERNEL_SCALE_VALUE );
	#endif
	total *= output_scale;


	vec3 result = total;
	return vec4(result, 1.);
}



