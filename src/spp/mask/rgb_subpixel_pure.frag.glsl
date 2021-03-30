#define USE_PIXEL_MASK 1
#define MASK_WIDTH 3
#define MASK_HEIGHT 3
#define MASK_LIT_COUNT 6

#define ROW(v)	vec3(v, 0, 0), vec3(0, v, 0), vec3(0, 0, v)
#define MASK_DATA	ROW(1), ROW(1), ROW(0)

