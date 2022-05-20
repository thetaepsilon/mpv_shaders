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

vec3 unit_interval(vec3 v) {
	return clamp(v, 0., 1.);
}

vec3 pick(vec3 _a, vec3 left, vec3 centre, vec3 right) {
	/*
	balanced three-way mix expected behaviour for values of a
	(pretend the args are float for a moment, operation is componentwise):
	<= -1: left * 1.0, centre * 0.0, right * 0.0
	 -0.5: left * 0.5, centre * 0.5, right * 0.0
	  0.0: left * 0.0, centre * 1.0, right * 0.0
	  0.5: left * 0.0, centre * 0.5, right * 0.5
	 >= 1: left * 0.0, centre * 0.0, right * 1.0

	simply done using two _clamped_ mixes
	(one from centre to left and one from centre to right)
	doesn't quite give us what we want initially alas:

	-1 case would give us 1 * left but also 1 * centre due to that mix's a being clamped to zero.
	-0.5 case, 0.5 * left and 1.5 * centre -
		0.5 centre from the left mix, 1.0 from the (again clamped) right mix.
	mirrored for the positive sign case.
	0.0 case, 2 * centre - 1*centre from each mix.

	turns out the solution is actually just to subtract 1*centre from the result.
	*/

	vec3 an = unit_interval(-_a);
	vec3 ap = unit_interval(_a);

	vec3 mn = mix(centre, left, an);
	vec3 mp = mix(centre, right, ap);
	vec3 result = mn + mp - centre;
	return result;
}

const float _shift = float(${shift});
// NB: no altmode for BGR vs RGB ordering defined.
// if the user desires this they can specify that shift be negative.
const vec3 shift = vec3(-_shift, 0., _shift);

vec4 hook() {
	vec2 centre = gl_FragCoord.xy;
	vec2 left = centre + vec2(-1, 0);
	vec2 right = centre + vec2(1, 0);

	vec3 result = pick(shift, get(left), get(centre), get(right));
	return vec4(result, 1.);
}
