--glsl-shader=$(spp funcs spp/transform_coupled/logarithm.frag.svar.glsl < transformed_exact_output.spp.svar.glsl | svar in MAINPRESUB stops 16 | cs) --glsl-shader=$(spp lutdata spp/nudge/horizontal/segment_5x_lcd_u_thin_blended.frag.glsl < simple_nudge_and_colour.spp.glsl | svar in MAINPRESUB d1 "(62. / 64.)" d2 "(56. / 64.)" | cs) --glsl-shader=$(svar in MAINPRESUB shift -1 < chroma_shift.svar.glsl | cs) --glsl-shader=$(spp lutdata spp/nudge/vstretch_x5.glsl < simple_nudge_and_colour.spp.glsl | svar in MAINPRESUB | cs)
