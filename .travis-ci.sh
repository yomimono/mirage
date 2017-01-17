eval `opam config env`
opam depext -uiy mirage
cd test && mirage configure -t ${MODE} && make depend && make && mirage clean && cd ..
git clone -b mirage-dev https://github.com/mirage/mirage-skeleton.git
make -C mirage-skeleton && rm -rf mirage-skeleton
