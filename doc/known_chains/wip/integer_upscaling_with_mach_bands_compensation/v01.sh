#!/bin/sh
set -eu;

exec mpvhk \
	$(downsample) \
	--linear-upscaling --linear-downscaling \
	--glsl-shader=$(spp kernel spp/blur_kernels/2d/edgedetect/3x3_laplacian_with_diagonals.frag.glsl < blur_kernel_2d.spp.svar.glsl \
		| svar \
			after LINEAR \
			in LINEAR \
			load_origin 1 \
			input_transform 'log2(max(data, vec3(0.)) + vec3(exp2(-16.)))' \
			output_transform '((original - (result / 64.)) / 256.) + vec3(1.)' \
		| cs) \
	--glsl-shader=$(svar at LINEAR in LINEAR x 3 y 1 out scale < integer_upscale_exact.svar.glsl | cs) \
	--glsl-shader=$(spp kernel spp/blur_kernels/1d/laplacian_1d.glsl < blur_kernel_1d.spp.svar.glsl \
		| svar \
			after LINEAR \
			in scale \
			xs 1. \
			load_origin 1 \
			input_transform '(data - vec3(1.)) * 256.' \
			output_transform 'exp2(original + (result * exp2(-4.)))' \
		| cs) \
	--glsl-shader=$(svar in scale shift 1 < chroma_shift.svar.glsl | cs) \
	--glsl-shader=$(spp lutdata spp/nudge/vstretch_x3.glsl < simple_nudge_and_colour.spp.glsl \
		| svar at LINEAR in scale \
		| cs) \
	--glsl-shader=$(svar in scale < autocentre_fixedsize.svar.glsl | cs) \
	"$@";
