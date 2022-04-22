//!HOOK ${after}
//!DESC downsampling pass: total area average, ${x}x${y:$x}
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in}.w ${x} /
//!HEIGHT ${in}.h ${y:$x} /

#define MAP_X ${x}
#define MAP_Y ${y:$x}

#define TEXF ${in} ## _tex
#define SZ (${in} ## _size)

// total number of samples, reciprocal to scale total to average.
const float scale = 1.0 / float(MAP_X * MAP_Y);



vec4 hook() {
	//if (mod(frame, 2.) < 1.) discard;

	int tx = int(gl_FragCoord.x);
	int ty = int(gl_FragCoord.y);

	int ox = tx * MAP_X;
	int oy = ty * MAP_Y;
	vec3 total = vec3(0.);
	for (int x = 0; x < MAP_X; x++) {
	for (int y = 0; y < MAP_Y; y++) {
		vec2 srcpix = vec2(ox + x, oy + y);
		vec2 srcpt = srcpix / SZ;
		vec3 data = TEXF(srcpt).rgb;
//#optreplace data = ${input_transform};
		total += data;
	}
	}
	total *= scale;
//#optreplace total = ${output_transform};
	return vec4(total, 1.);
}

