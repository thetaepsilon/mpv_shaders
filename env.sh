export PATH="$PATH:$PWD/bin";
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
hash mpvh || alias mpvh=mpv;

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
