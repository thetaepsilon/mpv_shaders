--linear-upscaling --linear-downscaling --glsl-shader=$(spp kernel spp/blur_kernels/separable/binomial/binomial_15x.frag.glsl extrabind spp/linear_op/crappy_linear_ypbpr.svar.frag.glsl < blur_kernel_1d.spp.svar.glsl | svar after LINEAR in LINEAR xs 1. input_transform "f(data)" output_transform "(f_undo(vec3(result.r, original.y + (1./256.), result.b)) * 0.9) + (vec3(1./128.) * original_raw)" load_origin 1 | cs) --glsl-shader=$(spp lutdata spp/nudge/vertical/folded/vstretch_x4_1thick_blurred_binomial_5x_from_10x.glsl < simple_nudge_and_colour.spp.glsl | svar at LINEAR in LINEAR out upscale | cs) --glsl-shader=$(svar in upscale < autocentre_fixedsize.svar.glsl | cs)