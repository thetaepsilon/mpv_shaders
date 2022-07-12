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



const float addm = ${am:1.};
const float exposure = ${e:0.75};

vec4 hook() {
	vec2 p = POS;
	vec3 reference = TEXF(p).rgb;
	vec3 data_bloom = BTEXF(p).rgb;

	reference = input_transform(reference);
	data_bloom = bloom_transform(data_bloom);


	vec3 addend = data_bloom * addm;

	//bool ab = fract(frame / 2.0) < 0.5;
	vec3 result = (reference + addend);

	result *= exposure;

	return vec4(result, 1.);
}



