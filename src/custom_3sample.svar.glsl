//!HOOK ${at:LINEAR}
//!BIND ${in}
//!DESC custom sampling kernel, 3-side
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h
#define SZ ${in}_size
#define TEXF ${in}_tex


const vec2 step = vec2(${step:1., 0.});


// custom include start
//#include? include
// custom include end



// probably will allow changing these later...
// most of the time we only are about vec3...
// (probably also an optimisation to tell mpv about COMPONENTS,
// but that would probably need custom shader logic integration outside of what svar can do)
#define SAMPLE vec3
#define SAMPLE_MASK(x) ((x).rgb)
#define SAMPLE_WRAP(x) vec4((x), 1.)




SAMPLE input_transform(SAMPLE data) {
//#optreplace data = ${input_transform};
	return data;
}

SAMPLE output_transform(SAMPLE result) {
//#optreplace result = ${output_transform};
	return result;
}

SAMPLE fetch(vec2 pixel) {
	vec2 pos = pixel / SZ;
	vec4 raw = TEXF(pos);
	SAMPLE loaded = SAMPLE_MASK(raw);
	SAMPLE result = input_transform(loaded);
	return result;
}

SAMPLE process(SAMPLE centre, SAMPLE a, SAMPLE b) {
	return ${process_expr};
}



vec4 hook() {
	vec2 origin = gl_FragCoord.xy;

	SAMPLE centre	= fetch(origin);
	SAMPLE a	= fetch(origin - step);
	SAMPLE b	= fetch(origin + step);

	SAMPLE result = process(centre, a, b);
	SAMPLE outcol = output_transform(result);
	return SAMPLE_WRAP(outcol); 
}

