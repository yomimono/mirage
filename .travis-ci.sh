opam depext -uiy mirage
git clone -b targets https://github.com/yomimono/mirage-skeleton.git
cd mirage-skeleton
eval `opam config env`
find . -name _build | xargs rm -rf
export MODE && make
