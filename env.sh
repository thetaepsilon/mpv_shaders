export PATH="$PATH:$PWD/bin";
export CACHESPONGE_HASHER=sha256sum;
pp() {
	cpp -C -ftrack-macro-expansion=0 -P -undef -nostdinc;
}
cs() {
	pp | cachesponge;
}
mpvhe() {
	mpvhk --glsl-shader=exact_output.glsl "$@";
}
