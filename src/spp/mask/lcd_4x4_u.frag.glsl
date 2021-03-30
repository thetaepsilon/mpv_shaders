#define USE_PIXEL_MASK 1
#define MASK_WIDTH 4
#define MASK_HEIGHT 4

#define ROW(v)	vec3(0), vec3(v), vec3(v), vec3(0)
#define MASK_DATA	ROW(1), ROW(1), ROW(1), ROW(0)

