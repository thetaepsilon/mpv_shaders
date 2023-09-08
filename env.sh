export PATH="$PWD/bin:$PATH";
export SHADER_SRC="$PWD/src";
export CACHESPONGE_HASHER=sha256sum;
pp() {
	cpp -C -ftrack-macro-expansion=0 -P -undef -nostdinc;
}
cs() {
	pp | cachesponge;
}



# mpv helpers
# this is just a force hwaccel wrapper that one can customise locally.
# if it doesn't exist it is is aliased to plain mpv.
# for instance, I have found it useful in the past to have mpvh be:
# mpv --hwaccel=vaapi "$@"
# for when detection was broken.
# it's not otherwise critical for the shaders though,
# as long as --vo=gpu is used.
# additionally, gles is used by default as it is the stricter subset in terms of shader language.
hash mpvh || alias mpvh='mpv --opengl-es=yes';

# assume the input has square pixels despite intended display aspect ratio
# (useful when using shader passes that handle the aspect ratio themselves):
mpvhz() {
	mpvh --video-aspect-override=0 "$@";
}

# always draw over the entire screen,
# regardless of input video's display aspect ratio.
# note that this by itself (without using a pixel-exact drawing shader)
# will stretch the video across the entire screen without preserving aspect.
# this is typically used with the exact_output shader passes,
# in order to have access to *all* screen pixels -
# mpvhz OTOH will only use the shaders to draw an aspect-preserving area.
mpvhk() {
	mpvh --no-keepaspect "$@";
}



# shader chain helpers (can be used with any mpv wrapper, theoretically).
# this one checks for a (previously set by something else)
# variable called "m" which denotes if downsampling should be done.
# this is useful for testing 3D content to emulate rendering that game or such at lower resolution.
# if it is "1", this helper emits nothing.
# otherwise, it will call svar on src/downsample_nearest_multiplier.svar.glsl,
# setting x to the value of m, run it into cs, then echo it as a shader argument.
# this is essentially intended to be used as mpv $(downsample) [other shaders here...].
downsample() {
	test -n "${m:-}" && {
		test "1" != "$m" && {
			echo --glsl-shader="$( \
				svar x "$m" in MAINPRESUB < \
					"$SHADER_SRC/downsample_nearest_multiplier.svar.glsl" \
				| cs
			)";
		};
	};
};
