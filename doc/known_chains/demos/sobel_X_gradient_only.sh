#!/bin/sh
set -eu;

exec mpvhk \
	--linear-upscaling \
	--linear-downscaling \
	--glsl-shader=$(\
		svar \
			after LINEAR \
			in LINEAR \
			out percep \
			expr 'pow(max(c, vec3(0.)), vec3(1./3.))' \
		< linear_transform.spp.svar.glsl \
		| cs) \
	--glsl-shader=$(\
		spp \
			kernel spp/blur_kernels/separable/binomial/binomial_21x.frag.glsl \
		< blur_kernel_separable.spp.glsl \
		| svar \
			after LINEAR \
			in percep \
			out blur \
		| cs) \
	--glsl-shader=$(\
		spp \
		kernel spp/blur_kernels/2d/edgedetect/sobel_x.frag.glsl \
		< blur_kernel_2d.spp.svar.glsl \
		| svar \
			after LINEAR \
			in percep \
			out sobelX \
			output_transform 'pow(max((abs(result) - vec3(0.25)), vec3(0.)), vec3(3.))' \
		| cs) \
	--glsl-shader=$(\
		svar \
			at LINEAR \
			in sobelX \
			out scaled \
			x 2 \
		< integer_upscale_exact.svar.glsl \
		| cs) \
	--glsl-shader=$(\
		svar \
			in scaled \
		< autocentre_fixedsize.svar.glsl \
		| cs) \
	"$@";

# ((result * .5) + vec3(0.5))
