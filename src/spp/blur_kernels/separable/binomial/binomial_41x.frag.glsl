const float kernel_data[] = float[](

1.,
40.,
780.,
9880.,
91390.,
658008.,
3838380.,
18643560.,
76904685.,
273438880.,
847660528.,
2311801440.,
5586853480.,
12033222880.,
23206929840.,
40225345056.,
62852101650.,
88732378800.,
113380261800.,
131282408400.,
137846528820.,
131282408400.,
113380261800.,
88732378800.,
62852101650.,
40225345056.,
23206929840.,
12033222880.,
5586853480.,
2311801440.,
847660528.,
273438880.,
76904685.,
18643560.,
3838380.,
658008.,
91390.,
9880.,
780.,
40.,
1.

);

const int kernel_radius = 20;
#define KERNEL_SCALE_VALUE (pow(2., -40.))
