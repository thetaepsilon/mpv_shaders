--glsl-shader=$(spp funcs spp/transform_coupled/logarithm.frag.svar.glsl < transformed_exact_output.spp.svar.glsl | svar in MAINPRESUB stops 16 | cs) --glsl-shader=$(spp lutdata spp/nudge/horizontal/segment_4x_lcd_u_evenpix_blended.frag.glsl edgedetect spp/edgedetect/darken.frag.svar.glsl < simple_nudge_and_colour.spp.glsl | svar in MAINPRESUB strength 1.5 d1 "(60. / 64.)" | cs) --glsl-shader=$(svar in MAINPRESUB shift -1 < chroma_shift.svar.glsl | cs) --glsl-shader=$(spp lutdata spp/nudge/vertical/vstretch_x6_doublegap_blended.glsl edgedetect spp/edgedetect/darken.frag.svar.glsl < simple_nudge_and_colour.spp.glsl | svar in MAINPRESUB strength 2. un1 -0.375 n1 0.1166666 ud1 0.875 d1 0.9375 | cs)