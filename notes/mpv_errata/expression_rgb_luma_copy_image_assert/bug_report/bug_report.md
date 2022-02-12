### Important Information

- mpv version 0.34.1(-dirty)
- Distro: Arch Linux
- source of mpv binary: distro package "mpv", package version 1:0.34.1-2
- window manager: bspwm version 0.9.10
- GPU and driver info: Mesa Intel(R) UHD Graphics 600 (GLK 2) (0x3185), mesa version 21.3.5, iris_dri.so

### Reproduction steps
- Write a minimal glsl shader (e.g. just returns a constant value - the glsl logic itself does not appear to be the issue) with a //!HOOK block and a //!COMPONENTS option with a value greater than what seems to make sense for the HOOKED texture of that hook point. e.g. for MAIN, MAINPRESUB etc set it to larger than 4, or larger than 1 for LUMA \(see attached [example](https://github.com/mpv-player/mpv/files/8053900/luma_example.glsl.txt)\) - the latter case can occur when using scripts to generate a shader that \(likely incorrectly\) assume COMPONENTS == 3 or 4 is always ok due to the return type of the hook\(\) function, but being instructed to hook into a texture for which the number of components that makes sense is less than that value.
- run mpv --no-config --glsl-shader=$the_above_shader.glsl $any_video

### Expected behavior
Error with clear explaination that the number of components does not make sense or is too large for the overwritten texture, or a warning that the shader is being ignored and continuing for the same reason.

### Actual behavior
mpv aborts and core dumps with the following:
``mpv: ../video/out/gpu/video.c:1333: copy_image: Assertion `*offset + count <= 4' failed.``

### Log file
See [attached luma_example.glsl.log](https://github.com/mpv-player/mpv/files/8053886/luma_example.glsl.log) for the --log-file output of the luma case example.
Note also [stdout/stderr data](https://github.com/mpv-player/mpv/files/8053895/stdout.txt) data as the assert causes mpv to terminate seemingly uncleanly.
I have the [output of systemd-coredump](https://github.com/mpv-player/mpv/files/8053942/mpv_coredump.txt) but currently no debug symbols available at the time of writing.



### Sample files
Example shader linked above in reproduction steps.




