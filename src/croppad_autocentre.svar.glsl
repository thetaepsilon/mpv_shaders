//!HOOK ${after:MAINPRESUB}
//!DESC gpu-accelerated crop and/or black pad pass, autocentering, ${w}x${h}
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${ow:$w}
//!HEIGHT ${oh:$h}




#define TEXF ${in} ## _tex
#define SZ (${in} ## _size)


const float outw = (${ow:$w});
const float outh = (${oh:$h});
const vec2 output_size = vec2(outw, outh);

// size of the rectangular window which may display pixels of the source texture.
// some parts of this area may still show black if it partly falls off the edge.
// it is this viewport that gets centered.
// the viewport naturally cannot be bigger than the output texture size.
const float vw = min((${w}), outw);
const float vh = min((${h}), outh);
const vec2 viewport_size = vec2(vw, vh);

// offset into output texture that the viewport starts at;
// this is half the available padding around the viewport to centre it.
// some care is taken here as an odd difference would cause Problems(tm) with texture sampling,
// namely by an extra +0.5 of a pixel causing blurry midpoint linear interpolation.
const vec2 _vo = (output_size - viewport_size) * 0.5;
const vec2 viewport_offset = vec2(floor(_vo.x), floor(_vo.y));

// offset into the source texture where the viewport starts.
// can be negative if one-sided padding is desired.
const vec2 source_offset = vec2(( ${x:0.} ), ( ${y:0.} ));


bool outside_s(float pix, float size) {
	return (pix < 0) || (pix > size);
}
bool outside(vec2 pix, vec2 size) {
	#define DIM(c) ( outside_s( pix.c , size.c ) )
	return DIM(x) || DIM(y) ;
	#undef DIM
}

vec4 blank() {
	// when returning black bars, most of the time we want to avoid any unneeded pixel writes,
	// so most of the time a discard is issued -
	// but resizing the window then creates AFuckenMess (!SysGhostRoll. #sorrynotsorry).
	// so every now and again return black without discarding to clean things up.
	// sadly we have to pick a hardcoded period number of frames here...
	if (int(mod(frame, 30)) == 0) {
		return vec4(0.);
	} else {
		discard;
	}
}

vec4 getdata(vec2 inpix) {
	// get into viewport coordinates...
	vec2 viewport_pix = inpix - viewport_offset;

	// firstly, if we're outside the viewport, we're gonna be black barred.
	// we also check if we're outside the source texture in a moment,
	// then the two areas are unioned via logical OR.
	bool out_of_viewport = outside(viewport_pix, viewport_size);

	vec2 source_pix = viewport_pix + source_offset;
	bool out_of_texture = outside(source_pix, SZ );

	vec2 source_pt = source_pix / SZ;
	bool outside = out_of_viewport || out_of_texture;

	// conditional on purpose.
	// there's a good chance large amounts of pixels will branch the same;
	// inside the source texture they'll all branch to read from the texture as normal,
	// and outside the texture in the black region they'll all branch to _not_ perform fetches,
	// potentially saving a heck of a lot of texture reads with little divergence cost,
	// save for around the edges of course.
	if (!outside) {
		return TEXF(source_pt);
	} else {
		return blank();
	}
}

vec4 hook() {
	return getdata(gl_FragCoord.xy);
}








