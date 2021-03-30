//!HOOK OUTPUT
//!DESC pixel mask spp debug

//#include mask
const vec3 pixel_mask[MASK_WIDTH * MASK_HEIGHT] = vec3[](
	MASK_DATA
);

vec4 hook() {
	int x = int(mod(gl_FragCoord.x, MASK_WIDTH));
	int y = int(mod(gl_FragCoord.y, MASK_HEIGHT));
	int idx = (y * MASK_WIDTH) + x;
	return vec4(pixel_mask[idx], 1.);
}

