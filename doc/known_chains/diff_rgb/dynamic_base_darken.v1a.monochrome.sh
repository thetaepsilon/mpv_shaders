--linear-upscaling --linear-downscaling --glsl-shader=$(svar after LINEAR in LINEAR out vin x $m < downsample_nearest_multiplier.svar.glsl | cs) --glsl-shader=$(svar after LINEAR in vin out blur x 25 < downsample_area.svar.glsl | cs) --glsl-shader=$(spp kernel spp/blur_kernels/separable/binomial/binomial_21x.frag.glsl < blur_kernel_separable.spp.glsl | svar after LINEAR in blur | cs) --glsl-shader=$(in=vin out=scale impl_diff_factor=v2 diffprescale=0.5 diffclamp=0.25 perceptual_gamma="pow(2., -20.)" extradata_bind=blur base_darken="$(tr -d "\\n\\t" < expr/diff_rgb/base_darken/bloom_extradata_v1.txt)" ./specials/diff_rgb | cs) --glsl-shader=$(spp lutdata spp/nudge/vstretch_x3.glsl < simple_nudge_and_colour.spp.glsl | svar at LINEAR in scale | cs) --glsl-shader=$(svar in scale < autocentre_fixedsize.svar.glsl | cs)