#!/bin/sh
set -eu;

logrange='16.';
logspace() {
	echo "log2(max(data, vec3(0.)) + vec3(exp2(-${1:-${logrange}})))";
}
log_difference_transport="(result / ${logrange}) + vec3(0.5)";

exec mpvhk \
	--linear-upscaling --linear-downscaling \
	--glsl-shader=$(\
		spp \
			include spp/lib/correlate_gradient.glsl \
		< custom_3sample.svar.glsl \
		| svar \
			in LINEAR \
			input_transform "pow(max(data, vec3(0.)), vec3(0.33))" \
			process_expr "pow(min((correlate_gradient(a, centre, b) * 4.), vec3(1.)), vec3(0.25))" \
			out gradient_v2 \
		| cs) \
	--glsl-shader=$(svar at LINEAR in gradient_v2 x 3 y 1 < integer_upscale_exact.svar.glsl | cs) \
	--glsl-shader=$(\
		spp \
			kernel spp/blur_kernels/2d/edgedetect/3x3_laplacian_with_diagonals.frag.glsl \
			extrabind spp/lib/log_safe_transport.glsl \
		< blur_kernel_2d.spp.svar.glsl \
		| svar \
			after LINEAR \
			in LINEAR \
			load_origin 1 \
			input_transform "$(logspace)" \
			output_transform "log_to_safe_transport((original - (result * exp2(-8.))))" \
		| cs) \
	--glsl-shader=$(svar at LINEAR in LINEAR x 3 y 1 out scale < integer_upscale_exact.svar.glsl | cs) \
	--glsl-shader=$(spp \
			kernel spp/blur_kernels/1d/laplacian_1d.glsl \
			extrabind spp/lib/log_safe_transport.glsl \
		< blur_kernel_1d.spp.svar.glsl \
		| svar \
			after LINEAR \
			in scale \
			xs 1. \
			load_origin 1 \
			input_transform 'log_from_safe_transport(data)' \
			output_transform "$log_difference_transport" \
			out laplacian \
		| cs) \
	--glsl-shader=$(\
		include=spp/lib/log_safe_transport.glsl \
		./specials/mix_n_expr \
			"vec4(exp2(    log_from_safe_transport(data1.rgb)    +    (((data3.rgb - vec3(0.5)) * ${logrange}) * exp2(  vec3(-8)  +  (data2.rgb * 5.)  ))    ),1.)" \
			scale gradient_v2 laplacian \
		| cs) \
	--glsl-shader=$(spp lutdata spp/nudge/vstretch_x3.glsl < simple_nudge_and_colour.spp.glsl \
		| svar at LINEAR in scale out final \
		| cs) \
	--glsl-shader=$(svar in final < autocentre_fixedsize.svar.glsl | cs) \
	"$@";

# --glsl-shader=$(svar in scale shift 1 < chroma_shift.svar.glsl | cs) \
# --glsl-shader=$(svar at LINEAR in gradient x 3 y 1 < integer_upscale_exact.svar.glsl | cs) \


