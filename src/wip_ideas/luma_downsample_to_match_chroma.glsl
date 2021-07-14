//!HOOK CHROMA
//!DESC downsample luma to match subsampled chroma: nearest neighbour
//!BIND LUMA
//!SAVE LUMA
//!WIDTH CHROMA.w
//!HEIGHT CHROMA.h

#define src_tex LUMA_tex
#define src_size LUMA_size
#define POS LUMA_pos

vec4 hook() {
	vec2 inpos = POS;
	vec2 srcpix = inpos * src_size;
	srcpix = floor(srcpix) + vec2(0.5);

	vec2 srcpt = srcpix / src_size;
	return src_tex(srcpt);
}

