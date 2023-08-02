// original (public domain): https://bottosson.github.io/posts/oklab/

vec3 linear_srgb_to_oklab(vec3 c) 
{
	float l = 0.4122214708f * c.r + 0.5363325363f * c.g + 0.0514459929f * c.b;
	float m = 0.2119034982f * c.r + 0.6806995451f * c.g + 0.1073969566f * c.b;
	float s = 0.0883024619f * c.r + 0.2817188376f * c.g + 0.6299787005f * c.b;

#define CBRT(f) (pow(max((f), 0.), float(0.33)))
	float l_ = CBRT(l);
	float m_ = CBRT(m);
	float s_ = CBRT(s);
#undef CBRT

	return vec3(
		0.2104542553f*l_ + 0.7936177850f*m_ - 0.0040720468f*s_,
		1.9779984951f*l_ - 2.4285922050f*m_ + 0.4505937099f*s_,
		0.0259040371f*l_ + 0.7827717662f*m_ - 0.8086757660f*s_
	);
}

vec3 oklab_to_linear_srgb(vec3 c) 
{
	// xyz -> Lab
	float l_ = c.x + 0.3963377774f * c.y + 0.2158037573f * c.z;
	float m_ = c.x - 0.1055613458f * c.y - 0.0638541728f * c.z;
	float s_ = c.x - 0.0894841775f * c.y - 1.2914855480f * c.z;

	float l = l_*l_*l_;
	float m = m_*m_*m_;
	float s = s_*s_*s_;

	return vec3(
		+4.0767416621f * l - 3.3077115913f * m + 0.2309699292f * s,
		-1.2684380046f * l + 2.6097574011f * m - 0.3413193965f * s,
		-0.0041960863f * l - 0.7034186147f * m + 1.7076147010f * s
	);
}
