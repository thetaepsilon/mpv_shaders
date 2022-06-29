
vec3 f(vec3 c) {

	float y = c.g;
	return vec3(c.r - y, y, c.b - y);
}


vec3 f_undo(vec3 c) {
	float y = c.y;
	return vec3(y + c.r, c.g, y + c.b);
}




