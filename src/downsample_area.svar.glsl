//!HOOK ${after:MAINPRESUB}
//!DESC downsampling pass: total area average, ${x}x${y:$x}
//!BIND ${in}
//!SAVE ${out:$in}
//!WIDTH ${in}.w ${x} /
//!HEIGHT ${in}.h ${y:$x} /
//!COMPONENTS 3

#define MAP_X ${x}
#define MAP_Y ${y:$x}

#define TEXF ${in} ## _tex
#define SZ (${in} ## _size)

// total number of samples, reciprocal to scale total to average.
const float scale = 1.0 / float(MAP_X * MAP_Y);

#if ${blur_mode:0}
#define P(x) ( x )
#else
#define P(x) ( int( x ) )
#endif

vec4 hook() {
	//if (mod(frame, 2.) < 1.) discard;

	int tx = P(gl_FragCoord.x);
	int ty = P(gl_FragCoord.y);

	int ox = tx * MAP_X;
	int oy = ty * MAP_Y;
	vec3 total = vec3(0.);
	for (int x = 0; x < MAP_X; x++) {
	for (int y = 0; y < MAP_Y; y++) {
		vec2 srcpix = vec2(ox + x, oy + y);
		vec2 srcpt = srcpix / SZ;
		vec3 data = TEXF(srcpt).rgb;
//#optreplace data = pow(clamp(data, 0., 1.), vec3(${input_gamma}));
		total += data;
	}
	}
	total *= scale;
//#optreplace total = pow(total, vec3(1.) / vec3(${output_gamma}));
	return vec4(total, 1.);
}

