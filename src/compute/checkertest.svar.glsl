//!HOOK ${at}
//!COMPUTE 32 32 32 1

void hook() {
	uvec2 block = gl_WorkGroupID.xy;
	uvec2 base_pos = 32 * block;

	ivec2 coord = ivec2(base_pos) + ivec2(gl_LocalInvocationID.x);
	imageStore(out_image, coord, vec4(1.));
}

