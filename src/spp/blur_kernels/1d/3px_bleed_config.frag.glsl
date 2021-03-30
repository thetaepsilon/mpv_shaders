const float D1 = ${pix_bleed};
const float kernel_data[] = float[](

D1,
1.,
D1

);

#define KERNEL_SCALE_VALUE (1. / (1. + (2 * D1)))
const int kernel_radius = 1;

