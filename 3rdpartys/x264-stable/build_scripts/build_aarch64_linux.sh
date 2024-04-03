#/bin/sh
x264_root_path=$(dirname $(readlink -f $0))/..
echo "当前脚本所在父目录为：${x264_root_path}"

ARCH=aarch64

# CPU=${ARCH} #build error
CPU=armv8-a

PREFIX=${x264_root_path}/install/${ARCH}-linux-x264-stable
TOOL_CHAIN_PREFIX=/data/wensha2/tool/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin/${ARCH}-linux-gnu-

HOST=arm-linux

ECFLAGS="-fPIC -march=${CPU}"
# ELDFLAGS="-Wl,-z,noexecstack,-z,relro,-z,now -nostdlib"
ELDFLAGS="-Wl,-z,noexecstack,-z,relro,-z,now"

configure()
{
    cd ${x264_root_path}
    ./configure \
    --prefix=$PREFIX \
    --cross-prefix=$TOOL_CHAIN_PREFIX \
    --extra-cflags="$ECFLAGS" \
    --extra-ldflags="$ELDFLAGS" \
    --host=$HOST \
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
    make -j
    make install
}

build

