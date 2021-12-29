cg=0.05;
--glsl-shader=$(spp function spp/linear_op/exponent.frag.svar.glsl < linear_transform.glsl | svar in MAINPRESUB e $cg | cs) --glsl-shader=$(spp lutdata spp/nudge/4x4_lcd_u.frag.glsl < simple_nudge_and_colour.spp.glsl | svar in MAINPRESUB output_gamma $cg d1 "30.5 / 32." | cs) --glsl-shader=exact_output.glsl
