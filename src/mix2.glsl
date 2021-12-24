//!HOOK ${at}
//!DESC mix two textures together
//!BIND ${in1}
//!BIND ${in2}
//!SAVE ${out:$in1}
//!WIDTH ${in1}.w
//!HEIGHT ${in1}.h

float ${in1}_m = ( ${m1} );
float ${in2}_m = ( ${m2} );

vec4 hook() {
	vec2 pix = gl_FragCoord.xy;
	vec4 total = vec4(0.);

	#define COLLECT(n) \
		vec2 n ## _npt = pix / n ## _size; \
		vec4 n ## _data = n ## _tex( n ## _npt ); \
		n ## _data *= n ## _m; \
		total += n ## _data

	COLLECT(${in1});
	COLLECT(${in2});

	return total;
}

