//!HOOK ${at:MAINPRESUB}
//!BIND HOOKED
//!BIND ${blur:blurdata}
//!DESC bloom using additive blur data ("blur data not included!")

#define TEXF HOOKED_tex
#define POS HOOKED_pos
#define BTEXF ${blur:blurdata}_tex


const float addm = ${am:1.};
const float exposure = ${e:0.75};

vec4 hook() {
	vec2 p = POS;
	vec3 reference = TEXF(p).rgb;
	vec3 addend = BTEXF(p).rgb * addm;

//#optreplace reference = pow(reference, vec3(${input_gamma}) );
//#optreplace addend = pow(addend, vec3(${input_gamma}) );

	//bool ab = fract(frame / 2.0) < 0.5;
	vec3 result = (reference + addend);

	result *= exposure;

	// ensure the result doesn't blare out - some shader passes don't like this
//#optreplace #if 0	// ${disable_clamp}
	result = min(result, vec3(1.0));
//#optreplace #endif	// ${disable_clamp}

//#optreplace result.rgb = pow(result.rgb, vec3(1.0) / vec3(${output_gamma}) );
	return vec4(result, 1.);
}



