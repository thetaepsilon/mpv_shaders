#define KERNEL_RADIUS_X 1
#define KERNEL_RADIUS_Y 1

#define v(x) (vec3(float(x) / 255.))

#define KERNEL_DATA \
	v(0x8b), v(0xf8), v(0x8b), \
	v(0xf8), v(0xff), v(0xf8), \
	v(0x8b), v(0xf8), v(0x8b)

#define KERNEL_SCALE 0.14143094841930118

