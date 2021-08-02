//!HOOK ${at:MAINPRESUB}
//!BIND ${in:$at}
//!SAVE ${out:$in}
//!WIDTH ${in}.w 2 *
//!HEIGHT ${in}.h



vec4 fetch(ivec2 pixel) {
	vec2 pos = (vec2(pixel) + vec2(0.5)) / ${in}_size;
	vec4 raw = ${in}_tex(pos);

	// curse you pesky out of gamut negatives
	vec4 fix = max(raw, vec4(0.0));
	return fix;
}

vec3 linear(vec4 raw) {
	// TODO: here because mpv is inflexible with LINEAR being non-resizeable
	return raw.rgb;
}

vec4 undo(vec3 v) {
	return vec4(v, 1.0);
}



vec4 hook() {
	vec2 target_pix = gl_FragCoord.xy;

	// we're inserting pixels on each row in-between adjacent source pixels.
	// however for some pixels in the output image we will be on top of an unchanged pixel.
	// figure that out as fast as possible and branch as early as feasible.

	vec2 srcpix_f = target_pix * vec2(0.5, 1.0);
	ivec2 srcpix = ivec2(srcpix_f);
	vec4 original = fetch(srcpix);

	if (mod(srcpix_f.x, 1.0) < 0.5) {
		return original;
	} else {
		// ... now we don't have to do too many texture fetches.
		// (XXX: we're assuming here that branching is worth it to dodge texture accesses.
		// might be useful to have an svar-controlled #if block if that is not the case.)
		
		vec3 current = linear(original);
		vec3 next = linear(fetch(srcpix + ivec2(1, 0)));

		// normally I'd be careful about GLES2 not defining divide by zero here,
		// not to mention normally being unable to use mix with a bvec...
		// but seeing as we're branching anyway which GLES2 can't into very well,
		// might as well loosen up.
		// note that I can't put a #version block myself as mpv prepends a header.
		vec3 chan_min = min(current, next);
		vec3 chan_max = max(current, next);
		// the only thing we have to be careful to dodge then in this case is 0/0.
		// (if one side was 0 and the other >0, the max would pick up the latter).
		bvec3 enable = greaterThan(chan_max, vec3(0.));
		vec3 p = chan_min / chan_max;	// <- gremlins hiding here!
		p = mix(vec3(0.0), p, enable);
		//p = pow(p, vec3(0.25));
		vec3 diff = vec3(1.0) - p;
		diff = max(diff, vec3(0.0));
		diff = pow(diff, vec3(1.4));
		p = exp2(diff * vec3(-1.0));

		vec3 result = p * chan_min;
		//result *= 0.8;
		return undo(result);
		//return vec4(0.);
	}
}

