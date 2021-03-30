//!HOOK MAINPRESUB
//!BIND HOOKED
//!BIND ${blur:blurdata}
//!DESC bloom using additive blur data ("blur data not included!")

#define TEXF HOOKED_tex
#define POS HOOKED_pos
#define BTEXF ${blur:blurdata}_tex


const float addm = ${am:1.};
const float exposure = ${e:0.75};
#define FVEC3(v) (vec3((F(v.r)), (F(v.g)), (F(v.b))))
vec4 hook() {
	vec2 p = POS;
	vec3 reference = TEXF(p).rgb;
	vec3 addend = BTEXF(p).rgb * addm;

	//bool ab = fract(frame / 2.0) < 0.5;
	vec3 result = (reference + addend);

	result *= exposure;

	// ensure the result doesn't blare out - some shader passes don't like this
	#define F(x) (min(x, 1.0))
	result = FVEC3(result);
	#undef F

//#optreplace result.rgb = pow(result.rgb, vec3(1 / ${output_gamma}));
	return vec4(result, 1.);
}



