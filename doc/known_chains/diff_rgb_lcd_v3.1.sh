--linear-upscaling --linear-downscaling --glsl-shader=$(out=upscale thc_diff_scale=0 subpixel_order=bgr base_darken="31./32." diffprescale=32.0 diffclamp=1.25 diffscale=8.0 input_transform="(max(col, vec3(0.)) + vec3(1./4096.)) / 4097. * 4096." ./specials/diff_rgb | cs) --glsl-shader=$(spp kernel spp/blur_kernels/separable/eval_compact/gaussian_7x__105wide_15x_condensed.glsl < blur_kernel_1d.spp.svar.glsl | svar after LINEAR in upscale input_gamma 0.33 output_gamma 0.33 xs 1. | cs) --glsl-shader=$(spp lutdata spp/nudge/vstretch_x3.glsl < simple_nudge_and_colour.spp.glsl | svar at LINEAR in upscale | cs)  --glsl-shader=$(svar in upscale lexp 2.0 < exact_output_altbuf.svar.glsl | cs)