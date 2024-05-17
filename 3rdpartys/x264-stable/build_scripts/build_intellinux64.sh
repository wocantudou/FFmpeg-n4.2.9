#/bin/sh
x264_root_path=$(dirname $(readlink -f $0))/..
echo "当前脚本所在父目录为：${x264_root_path}"

ARCH=x86_64

CPU=${ARCH} 

PREFIX=${x264_root_path}/install/${ARCH}-intellinux64-x264-stable

configure()
{
    cd ${x264_root_path}
    ./configure \
    --prefix=$PREFIX \
    --disable-asm \
    --disable-gpl  \
    --enable-pic    \
    --enable-static 
}

build()
{
    configure
    cd ${x264_root_path}
    make clean
    make -j2
    make install
}

build
