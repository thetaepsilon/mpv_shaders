ivec2 pick_2x2[] = ivec2[](
	ivec2(0, 0),
	ivec2(1, 0),
	ivec2(1, 1),
	ivec2(0, 1)
);

bool act(vec2 fpix, int fnum) {
	int pick = int(mod(float(fnum), 4.0));
	ivec2 data = pick_2x2[pick];

	ivec2 current = ivec2(mod(fpix, vec2(2.0)));
	return any(notEqual(current, data));
}

