//!HOOK POSTKERNEL
//!DESC repeat image tiler
//!BIND ${in:PREKERNEL}

#define SZ ${in:PREKERNEL}_size
#define TEX ${in:PREKERNEL}_tex

vec4 hook() {
	vec2 pix = mod(gl_FragCoord.xy, SZ);
	vec2 pt = pix / SZ;

	return TEX(pt);
}
