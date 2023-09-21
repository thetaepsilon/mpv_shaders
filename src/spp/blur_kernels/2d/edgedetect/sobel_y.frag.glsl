#define KERNEL_RADIUS_X 1
#define KERNEL_RADIUS_Y 1

#define KERNEL_DIRECT_DEFINE 1

#define V(x) vec3(float(x))
// XXX: this could REALLY benefit from a 'sparse' kernel shader.
const vec3 kernel_data[KERNEL_SIZE] = vec3[](
	V( 1), V( 2), V( 1),
	V( 0), V( 0), V( 0),
	V(-1), V(-2), V(-1)
);
#undef V

const float kernel_scale = 1.0;

