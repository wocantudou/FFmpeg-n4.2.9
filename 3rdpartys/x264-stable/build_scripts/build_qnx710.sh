#/bin/sh
x264_root_path=$(dirname $(readlink -f $0))/..
echo "当前脚本所在父目录为：${x264_root_path}"

source /data/wensha2/tool/QNX/EXP_Gen3_Gen4_SDP71_HV22_20220608/qnxsdp-env.sh
ARCH=aarch64

# CPU=${ARCH} #build error
CPU=armv8-a

PREFIX=${x264_root_path}/install/$ARCH-qnx710-x264-stable
TOOL_CHAIN_PREFIX=${ARCH}-unknown-nto-qnx7.1.0-

# HOST=x86_64-qnx # build error
HOST=x86-qnx
# HOST=${ARCH}-qnx #why qnx not x86_64

ECFLAGS="-fPIC -march=${CPU}"
ELDFLAGS="-Wl,-z,noexecstack,-z,relro,-z,now -nostdlib"

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
    make -j2
    make install
}

build

