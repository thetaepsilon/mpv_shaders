//!HOOK LUMA
//!DESC transform rgb according to arbitrary expression
//!BIND LUMA
//!SAVE LUMA
//!WIDTH LUMA.w
//!HEIGHT LUMA.h
//!COMPONENTS 3
vec4 hook() {
 vec3 c = LUMA_tex(LUMA_pos).rgb;
  c = vec3(0.5);
 return vec4(c, 1.);
}
