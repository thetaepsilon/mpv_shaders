//!HOOK MAINPRESUB
//!DESC XYZ greyscale luminosity, interpreting RGB under equal energy whitepoint (E)
//!BIND HOOKED
//!SAVE ${out:luminosity}
//!WIDTH HOOKED.w
//!HEIGHT HOOKED.h
//!COMPONENTS ${chans:1}
const vec3 weights = vec3(	0.1762044,	0.8129847,	0.0108109	);
vec4 hook() {
	// only doing part of a matrix operation here,
	// so we have to do the addition of the components ourself manually.
	// normally for a full XYZ transform we would have a full mat3 above.
	vec4 orig = HOOKED_tex(HOOKED_pos);
	vec3 m = orig.rgb * weights;
	float Y = m.r + m.g + m.b;
	// negative channel value protection as those can appear sometimes.
	Y = max(Y, 0.);
	orig.rgb = vec3(Y);
	return orig;
}

