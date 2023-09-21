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
			in blur \
			out sobelX \
			output_transform '(result * .5) + vec3(0.5)' \
		| cs) \
	--glsl-shader=$(\
		spp \
			kernel spp/blur_kernels/2d/edgedetect/sobel_y.frag.glsl \
		< blur_kernel_2d.spp.svar.glsl \
		| svar \
			after LINEAR \
			in blur \
			out sobelY \
			output_transform '(result * .5) + vec3(0.5)' \
		| cs) \
	--glsl-shader=$( \
		out=sobelM \
		include=spp/lib/componentwise_distance.glsl \
		./specials/mix_n_expr \
			'vec4(
				(
					vec3(
						greaterThanEqual(
							componentwise_distance(
								((data1.rgb - vec3(0.5)) * 2.),
								((data2.rgb - vec3(0.5)) * 2.)
							),
							vec3(1./8.)
						)
					)     
				),
				1.
			)' \
			sobelX sobelY \
		| cs) \
	--glsl-shader=$(\
		svar \
			at LINEAR \
			in sobelM \
			out scaled \
			x 3 \
		< integer_upscale_exact.svar.glsl \
		| cs) \
	--glsl-shader=$(\
		svar \
			in scaled \
		< autocentre_fixedsize.svar.glsl \
		| cs) \
	"$@";
