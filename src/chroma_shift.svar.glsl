//!HOOK ${after:LINEAR}
//!DESC colour-varying image shift, horizontal
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h

vec3 get(vec2 pix_in) {
	vec2 pos = pix_in / ${in}_size;
	vec3 data = ${in}_tex(pos).rgb;
	return data;
}


const float shift = float(${shift});
// XXX: we could probably have a more exotic pixel ordering,
// as opposed to just BGR or RGB?
// as well as potentially an arbitrary direction shift.
// it'd just be as simple as multiplying a vector by the shift amount.
const vec2 red_shift = vec2(-shift, 0.);
const vec2 green_shift = vec2(0., 0.);
const vec2 blue_shift = vec2(shift, 0.);

vec4 hook() {
	vec2 origin = gl_FragCoord.xy;
//#optreplace origin = origin + vec2(${offset});

	float r = get(origin + red_shift).r;
	float g = get(origin + green_shift).g;
	float b = get(origin + blue_shift).b;
	
	return vec4(r, g, b, 1.);
}
