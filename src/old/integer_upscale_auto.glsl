//!HOOK ${postphase:POSTKERNEL}
//!DESC integer upscale, automatic factor determination (assumes SAR=1:1)
//!BIND HOOKED
//!BIND ${in:PREKERNEL}

#define TEXF ${in:PREKERNEL}_tex
#define SZ ${in:PREKERNEL}_size



// these are done outside of any function to hint they could be treated as uniforms.
// whether this will actually help / get optimised is uncertain, but we can't use const either.
// it's still valid GLSL in any case.

// how many times bigger the output is than the input in each dimension.
// note if the output is _smaller_ that will be dealt with later.
vec2 scales_f = HOOKED_size / SZ;
// those are then rounded down to the largest integer multiple that will fit on-screen,
// then and ensured they are at least 1 (a scale of 0 or negative would not really be useful).
vec2 scales = max(floor(scales_f), vec2(1.));
// we then pick the smallest of the two dimensions to ensure aspect ratio preservation,
// while still ensuring everything fits on-screen.
// or alternatively use the biggest and have auto-centering truncation behaviour if desired.
#if ${use_larger:0}
#define PICKDIM max
#else
#define PICKDIM min
#endif
// allow the svar mechanism to override in any case.
float scale = ${scale:PICKDIM(scales.x, scales.y)};

// now that we have a scale factor, determine what offset needs applying to gl_FragCoord.
// this will apply an auto-centering of the input video on-screen.
// negative values for the padding indicate truncation.
vec2 used_output_size = scale * SZ;
vec2 padding = floor((HOOKED_size - used_output_size) * 0.5);



bool outofbounds(float f) {
	return (f < 0.) || (f > 1.);
}
vec4 vsampler(vec2 pix) {
	// pretty much follows the recipe for integer_upscale_exact here...
	// the one addition is a bounds check to return black instead of clamping to edge.
	vec2 srcpix = floor(pix / scale) + vec2(0.5);
	vec2 pos = srcpix / SZ;
	bool nowrite = (outofbounds(pos.x) || outofbounds(pos.y));
	return nowrite ? vec4(0.) : TEXF(pos);
}

vec4 hook() {
	vec2 inpix = gl_FragCoord.xy;
	inpix -= padding;
	return vsampler(inpix);
}
