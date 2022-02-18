


const float step_mult = float(${log_step_mult:1.0});
const float step_undo = 1.0 / step_mult;

vec3 f(vec3 _c) {
	// heck yoouuu GLES twoooooo!
	bvec3 nonsense_components = lessThanEqual(_c, vec3(0.));

	// set the things we don't care about to something that will work,
	// in order to avoid unspecified values (including potential NaNs) in GLES2.
	vec3 fnc = vec3(nonsense_components);
	vec3 safe = mix(_c, vec3(1.0), vec3(fnc));

	vec3 l = log2(safe);
	// slightly out of channel values will get made more so, so perform safety clamp.
	// (<= 1.0 values will become <= 0.0 in log space)
	l = min(l, vec3(0.));

	l *= step_mult;
	l = ceil(l);
	l *= step_undo;

	vec3 r = pow(vec3(2.0), l);
	r = mix(r, vec3(0.0), fnc);

	return r;
}
