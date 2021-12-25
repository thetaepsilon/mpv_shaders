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


const float addm = ${am:1.};
const float exposure = ${e:0.75};

vec4 hook() {
	vec2 p = POS;
	vec3 reference = TEXF(p).rgb;
	vec3 data_bloom = BTEXF(p).rgb;
	vec3 addend = data_bloom * addm;

	//bool ab = fract(frame / 2.0) < 0.5;
	vec3 result = (reference + addend);

	result *= exposure;

	// ensure the result doesn't blare out - some shader passes don't like this
//#optreplace #if 0	// ${disable_clamp}
	result = min(result, vec3(1.0));
//#optreplace #endif	// ${disable_clamp}

	return vec4(result, 1.);
}



