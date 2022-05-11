//!HOOK ${after}
//!DESC downsampling pass: total area average, ${x}x${y:$x}
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in}.w ${x} /
//!HEIGHT ${in}.h ${y:$x} /


//#include? extrabind

const int sample_count_x = ${x};
const int sample_count_y = ${y:$x};

#define TEXF ${in} ## _tex
#define SZ (${in} ## _size)

const int sample_count = sample_count_x * sample_count_y;



vec4 hook() {
	//if (mod(frame, 2.) < 1.) discard;

	int tx = int(gl_FragCoord.x);
	int ty = int(gl_FragCoord.y);

	int ox = tx * sample_count_x;
	int oy = ty * sample_count_y;

	// note origin must be +0.5 still.
	// we don't wnat straddle sampling.
	vec2 origin = vec2(ox, oy) + vec2(0.5);

	vec3 accum = vec3(${init_expr:0.});
	for (int x = 0; x < sample_count_x; x++) {
	for (int y = 0; y < sample_count_y; y++) {
		vec2 offset = vec2(x, y);
		vec2 srcpix = origin + offset;
		vec2 srcpt = srcpix / SZ;
		vec3 data = TEXF(srcpt).rgb;
//#optreplace data = ${input_transform};
		accum = ${accum_expr:accum + data};
	}
	}
	vec3 result = ${result_expr: accum / float(sample_count)};
//#optreplace result = ${output_transform};
	return vec4(result, 1.);
}

