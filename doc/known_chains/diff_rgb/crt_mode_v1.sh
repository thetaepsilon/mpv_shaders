--linear-upscaling --linear-downscaling --glsl-shader=$(out=upscale perceptual_gamma="1./8192." diffclamp=0.1 diffscale=4.0 crt_mode=1 ./specials/diff_rgb | cs) --glsl-shader=$(spp kernel spp/blur_kernels/separable/binomial/binomial_9x.frag.glsl < blur_kernel_1d.spp.svar.glsl | svar after LINEAR in upscale input_gamma 0.67 output_gamma 0.67 xs 1. | cs) --glsl-shader=$(spp lutdata spp/nudge/vstretch_x3.glsl < simple_nudge_and_colour.spp.glsl | svar at LINEAR in upscale | cs) --glsl-shader=$(svar in upscale < autocentre_fixedsize.svar.glsl | cs)