--linear-upscaling --linear-downscaling --glsl-shader=$(at=LINEAR in=LINEAR out=upscale ./specials/transform_pixels ./specials/data/transform/threshold_log/ | cs) --glsl-shader=$(spp lutdata spp/nudge/horizontal/segment_5x_lcd_u_evenpix_blended_colourtamper.frag.glsl < simple_nudge_and_colour.spp.glsl | svar at LINEAR in upscale input_transform "pow(vec3(2.0), data)" input_transform_clamp 0 | cs) --glsl-shader=$(spp lutdata spp/nudge/vstretch_x5.glsl < simple_nudge_and_colour.spp.glsl | svar at LINEAR in upscale | cs) --glsl-shader=$(svar in upscale < exact_output_altbuf.svar.glsl | cs)