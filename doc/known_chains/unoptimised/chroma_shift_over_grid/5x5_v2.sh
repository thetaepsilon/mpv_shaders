--glsl-shader=$(spp funcs spp/transform_coupled/logarithm.frag.svar.glsl < transformed_exact_output.spp.svar.glsl | svar in MAINPRESUB stops 16 | cs) --glsl-shader=$(spp lutdata spp/nudge/5x5_lcd_u_thin_blended.frag.glsl < simple_nudge_and_colour.spp.glsl | svar in MAINPRESUB d1 "(61. / 64.)" d2 "(58. / 64.)" | cs) --glsl-shader=$(svar in MAINPRESUB shift -1 < chroma_shift.svar.glsl | cs)