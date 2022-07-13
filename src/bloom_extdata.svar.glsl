//!HOOK ${at}
//!BIND ${in}
//!BIND ${blur}
//!SAVE ${out:$in}
//!WIDTH ${in}.w
//!HEIGHT ${in}.h
//!DESC bloom using additive blur data ("blur data not included!")

#define TEXF ${in}_tex
#define POS ${in}_pos
#define BTEXF ${blur}_tex



vec3 input_transform(vec3 data) {

//#optreplace data = ${input_transform};
	return data;
}

vec3 bloom_transform(vec3 data) {

//#optreplace data = ${bloom_transform:$input_transform};

	return data;
}

vec3 output_transform(vec3 result) {

//#optreplace result = ${output_transform};

	return result;
}



const float m = float(${mix:0.5});

vec4 hook() {
	vec2 p = POS;
	vec3 reference = TEXF(p).rgb;
	vec3 data_bloom = BTEXF(p).rgb;

	reference = input_transform(reference);
	data_bloom = bloom_transform(data_bloom);

	vec3 result = mix(reference, data_bloom, m);

	result = output_transform(result);

	return vec4(result, 1.);
}



