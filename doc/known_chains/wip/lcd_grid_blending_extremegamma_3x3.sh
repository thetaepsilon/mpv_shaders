cg=0.02;
--glsl-shader=$(spp function spp/linear_op/exponent.frag.svar.glsl < linear_transform.glsl | svar in MAINPRESUB e $cg | cs) --glsl-shader=$(spp lutdata spp/nudge/3x3_lcd_u_blended.frag.glsl < simple_nudge_and_colour.spp.glsl | svar in MAINPRESUB output_gamma $cg d1 "31. / 32." | cs) --glsl-shader=exact_output.glsl
