--linear-upscaling --linear-downscaling --glsl-shader=$(spp lutdata spp/nudge/4x4_lcd_rgb.frag.glsl < simple_nudge_and_colour.spp.glsl | svar in MAINPRESUB | cs) --glsl-shader=$(svar after LINEAR in LINEAR l 1 r 0 < bar_filter_horizontal.svar.glsl | cs) --glsl-shader=$(spp kernel spp/blur_kernels/2d/circular_3x3_3_7ths_condensed.frag.glsl < blur_kernel_2d.spp.svar.glsl | svar after LINEAR in LINEAR input_gamma 0.5 output_gamma 0.5 | cs) --glsl-shader=exact_output.glsl "$t"
