#define KERNEL_RADIUS_X 1
#define KERNEL_RADIUS_Y 1

#define v(x) (vec3(float(x) / 255.))

#define KERNEL_DATA \
	v(0x00), v(0x1c), v(0x00), \
	v(0x4c), v(0xff), v(0x4c), \
	v(0x00), v(0x1c), v(0x00)

#define KERNEL_SCALE 0.5704697986577181
