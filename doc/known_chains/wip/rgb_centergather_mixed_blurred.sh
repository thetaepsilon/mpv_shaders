--glsl-shader=$(svar gamma 2.2 < gamma_exact_output.svar.glsl | cs) --glsl-shader=$(spp lutdata spp/nudge/3x3_lcd_u_rgb_mixed.svar.glsl < simple_nudge_and_colour.spp.glsl | svar in MAINPRESUB | cs) --glsl-shader=$(spp kernel spp/blur_kernels/separable/gaussian_approx_truncated_9x_60iter_3wide.frag.glsl < blur_kernel_1d.spp.svar.glsl | svar in MAINPRESUB xs 1. input_gamma 0.33 output_gamma 0.33 e "1.42, 1.68, 1.42" | cs)
