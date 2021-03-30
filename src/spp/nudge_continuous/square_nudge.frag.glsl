
#define USE_DRIFT_TRANSFORM 1
vec2 transform_drift(vec2 orig) {
	vec2 signs = vec2(sign(orig.x), sign(orig.y));
	vec2 sq = orig * orig;	// note sign cancellation anyway, so no abs
	sq *= 2.;	// 0..0.5 -> 0..0.25, so rescale
	sq *= signs;	// re-apply direction
	return sq;
}

