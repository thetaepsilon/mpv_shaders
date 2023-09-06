vec3 unsharp_mask(vec3 original, vec3 blurred, vec3 control) {
	return (original + ((original - blurred) * control));
}
