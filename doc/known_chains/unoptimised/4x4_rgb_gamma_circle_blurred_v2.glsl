--linear-upscaling --linear-downscaling --glsl-shader=$(spp lutdata spp/nudge/4x4_lcd_prebar.glsl < simple_nudge_and_colour.spp.glsl | svar at LINEAR in LINEAR out upscale | cs) --glsl-shader=$(spp kernel spp/blur_kernels/2d/circular_3x3_3_7ths_condensed.frag.glsl < blur_kernel_2d.spp.svar.glsl | svar after LINEAR in upscale input_gamma 0.33 output_gamma 0.33 | cs) --glsl-shader=$(svar after LINEAR in upscale shift 1.0 < chroma_shift.svar.glsl | cs) --glsl-shader=$(svar in upscale < exact_output_altbuf.svar.glsl | cs)
