#define KERNEL_RADIUS_X 1
#define KERNEL_RADIUS_Y 1

#define R1 X(139) JOIN X(248) JOIN X(139)
#define R2 X(248) JOIN X(55) JOIN X(248)
#define DATA R1 JOIN R2 JOIN R1

#define KERNEL_DIRECT_DEFINE 1

#define V(x) (float(x) / 255.)
#define X(x) (vec3( V(x) ))
#define JOIN ,
const vec3 kernel_data[KERNEL_SIZE] = vec3[](
	DATA
);
#undef X

#define X(x) V(x)
#define JOIN +
const vec3 kernel_scale = vec3((1.0 / (DATA) ));
#undef X


