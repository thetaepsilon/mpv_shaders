--glsl-shader=$(spp kernel spp/blur_kernels/separable/gaussian_approx_truncated_11x_67iter_3wide.frag.glsl < blur_kernel_separable.spp.glsl | svar in MAINPRESUB input_gamma 1.7 out blurdata | cs) --glsl-shader=$(spp lutdata spp/nudge/vstretch_x3.glsl < simple_nudge_and_colour.spp.glsl | svar in MAINPRESUB vstretch_rowdim 0.33 | cs) --glsl-shader=$(svar at POSTKERNEL in POSTKERNEL blur blurdata am 0.4 e 1.0 < bloom_extdata.svar.glsl | cs)
