#define KERNEL_RADIUS_X 1
#define KERNEL_RADIUS_Y 1

#define KERNEL_DIRECT_DEFINE 1

#define V(x) vec3(float(x))
const vec3 kernel_data[KERNEL_SIZE] = vec3[](
	V(-1), V(-1), V(-1),
	V(-1), V( 8), V(-1),
	V(-1), V(-1), V(-1)
);
#undef V

const float kernel_scale = 0.125;



