--glsl-shader=$(spp funcs spp/transform_coupled/exponent.frag.glsl < mapped_scale_coupled.spp.glsl | svar at MAINPRESUB e 0.73333333 | cs) --glsl-shader=$(spp kernel spp/blur_kernels/separable/gaussian_approx_truncated_23x_112iter_3wide.frag.glsl < blur_kernel_1d.spp.svar.glsl | svar in MAINPRESUB xs 1. | cs) --glsl-shader=$(svar in MAINPRESUB dim 0. < crappy_scanlines.svar.glsl | cs) --glsl-shader=$(spp kernel spp/blur_kernels/separable/gaussian_approx_7x_condensed.frag.glsl < blur_kernel_1d.spp.svar.glsl | svar in MAINPRESUB ys 1. input_gamma 6.6 output_gamma 6.6 e 2 | cs)
