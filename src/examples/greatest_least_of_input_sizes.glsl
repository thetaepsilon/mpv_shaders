//!HOOK ${at}
//!DESC size expressions: {max width, min height} of two inputs
//!BIND ${in1}
//!BIND ${in2}
//!SAVE ${out}
//!WIDTH ${in1}.w ${in1}.w ${in2}.w > * ${in2}.w ${in1}.w ${in2}.w < * +
//!HEIGHT ${in1}.h ${in1}.h ${in2}.h < * ${in2}.h ${in1}.h ${in2}.h > * +

// you can debug the value of a boolean comparison
// (whose value is 0 or 1 for false or true)
// something like this.
// note the 1 + makes it 1 for false and 2 for true,
// otherwise you'll make opengl VERY unhappy with a size-zero texture.
// ${in1}.w ${in2}.w > 1 +

// for maximum:
// ${in1}.w ${in1}.w ${in2}.w > * ${in2}.w ${in2}.w ${in1}.w > * +
// for minimum flip the gt/lt operators.

vec4 hook() {
	return vec4(1.0);
}

