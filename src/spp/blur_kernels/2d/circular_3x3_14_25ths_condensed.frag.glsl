#define KERNEL_RADIUS_X 1
#define KERNEL_RADIUS_Y 1

#define v(x) (vec3(float(x) / 255.))

#define KERNEL_DATA \
	v(0x04), v(0x49), v(0x04), \
	v(0x49), v(0xff), v(0x49), \
	v(0x04), v(0x49), v(0x04)

#define KERNEL_SCALE 0.45293072824156305

