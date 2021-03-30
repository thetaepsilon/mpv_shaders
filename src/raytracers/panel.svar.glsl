//!HOOK OUTPUT
//!DESC raytrace rendered input: rotatable panel (NB: plane aspect ratio not preserved!)
//!BIND OUTPUT
//!BIND ${in}



bool outside(float v) {
	return (v < 0.) || (v > 1.);
}

vec2 sz = ${in}_size;
float largest = max(sz.x, sz.y);
vec2 scale_to_uv = vec2(largest) / sz;

vec4 sample_plane(vec2 xy) {
	// recenter +-1.0 onto 0..1 (uncenter it).
	// also apply correction from unit square first.
	xy *= scale_to_uv;
	vec2 pos = (xy + vec2(1.)) * 0.5;

	if (outside(pos.x) || outside(pos.y)) discard;
	return ${in}_tex(pos);
}



//const mat3 rot = mat3(
//	c
//);

const vec3 ws_camera = vec3(0.);
const vec3 ws_plane_center = vec3(0, 0, 1.8);

vec4 hook() {
	// first off we need to figure out a ray direction.
	// we assume to begin from a point at the origin representing the camera.
	// we will assume a frustrum plane at Z = +1.0.
	// (hey, we're raytracing, we get to pick handedness!)
	// our screen space coordinates give us some X/Y position on that plane.
	// we will use that to normalise a ray vector direction from.

	// have the largest screen axis represent 1.0, the smaller one is <1.0 width.
	// not any real reason for this bar matching what happens with the raytraced plane later.
	vec2 uncentered_screenspace = gl_FragCoord.xy;
	#define OP max
	float largest = OP(uncentered_screenspace.x, uncentered_screenspace.y);

	// reposition screenspace coordinates to be center weighted.
	vec2 screenspace = uncentered_screenspace - (OUTPUT_size * 0.5);

	// coords will be at most +- 0.5 * largest now, so to get a max of 1.0...
	vec2 ray_xy = (screenspace / largest) * 2;

	// now with the Z = 1.0 plane assumption, this means we essentially have a 45deg FOV.
	// get us that ray vector already...
	vec3 ray = normalize(vec3(ray_xy, 1.0));



	// next up, rendering the plane.
	// we describe the video plane as a centre point and it's xyz basis vectors.
	// firstly rebase the camera position to be relative to this ("plane space").
	vec3 ps_camera = ws_camera - ws_plane_center;

	// rotation of camera position and ray dir skipped for now...
	vec3 ps_ray = ray;
	
	// now the ray origin will be some (negative) Z distance from the plane.
	// we can intersect the ray and the plane by advancing the ray enough steps,
	// such that Z_ps becomes zero.
	float steps = -ps_camera.z / ps_ray.z;
	vec3 ps_intersection = ps_camera + (steps * ps_ray);
	return sample_plane(ps_intersection.xy);


	// debug ray dir check
	// vec2 xycol = (ray.xy + vec2(1.)) * 0.5;
	// return vec4(xycol, ray.z, 1.);
}

