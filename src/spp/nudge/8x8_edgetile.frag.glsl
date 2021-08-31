//!WIDTH ${in}.w 8 *
//!HEIGHT ${in}.h 8 *
#define HPIXSZ 8
#define VPIXSZ 8


#define USE_MODULATION_LUT 1

#define N (vec3(1.))
#define D (vec3(0.5))
#define TR D, D, D, D, D, D, D, D
#define CR D, N, N, N, N, N, N, D
#define DATA TR, CR, CR, CR, CR, CR, CR, TR
vec3 modulate_lut[] = vec3[](
	DATA
);
#undef N
#undef D
#undef CR
#undef TR
#undef DATA

#define N (vec2(0.))
#define E (vec2(0.9619))
#define I (vec2(0.6913))
#define USE_DRIFT_LUT 1
#define ER E, E, E, E, E, E, E, E
#define IR E, I, I, I, I, I, I, E
#define CR E, I, N, N, N, N, I, E
#define DATA ER, IR, CR, CR, CR, CR, IR, ER
vec2 drift_lut[] = vec2[](
	DATA
);



#undef TR
#undef CR

