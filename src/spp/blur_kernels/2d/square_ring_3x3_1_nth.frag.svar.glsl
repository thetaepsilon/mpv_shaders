#define KERNEL_RADIUS_X 1
#define KERNEL_RADIUS_Y 1

#define v(x) (vec3(x))
#define D1 (1. / ${ring_n})

#define KERNEL_DATA \
	v(D1), v(D1), v(D1), \
	v(D1), v(1.), v(D1), \
	v(D1), v(D1), v(D1)

#define KERNEL_SCALE (1. / (1. + (8 * D1)))

