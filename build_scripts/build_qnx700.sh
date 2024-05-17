#/bin/sh
ffmpeg_root_path=$(dirname $(readlink -f $0))/..
echo "当前脚本所在父目录为：${ffmpeg_root_path}"

ARCH=aarch64
# bulid x264-stable
# {
sh ${ffmpeg_root_path}/3rdpartys/x264-stable/build_scripts/build_qnx700.sh
X264_PATH=${ffmpeg_root_path}/3rdpartys/x264-stable/install/${ARCH}-qnx700-x264-stable
X264_LIB=$X264_PATH/lib
X264_HEADER=$X264_PATH/include
# }
source /data/wensha2/tool/QNX/sv-g6sh-qnx-system-sdk/qnxsdp-env.sh
TARGET_OS=qnx

# CPU=${ARCH}
CPU=armv8-a
# PREFIX=${ffmpeg_root_path}/install/$ARCH-qnx700-ffmpeg4.2.9
# PREFIX=/data/wensha2/tool/ffmpeg4.2.9/install/$ARCH-qnx700-ffmpeg4.2.9
PREFIX=/home/wensha2/workspace/opt/ffmpeg4.2.9/install/$ARCH-qnx700-ffmpeg4.2.9

TOOL_CHAIN_PREFIX=aarch64-unknown-nto-qnx7.0.0-

ECFLAGS="-fPIC -march=${CPU} -I${X264_HEADER}"
# ECXXFLAGS="-std=c++11 -fPIC -march=${CPU} -I${X264_HEADER}"
ECXXFLAGS="${ECFLAGS} -std=c++11"
ELDFLAGS="-Wl,-z,noexecstack,-z,relro,-z,now -L${X264_LIB}"

configure()
{
    cd ${ffmpeg_root_path}
    ./configure \
    --prefix=$PREFIX \
    --enable-cross-compile \
    --target-os=$TARGET_OS \
    --arch=$ARCH \
	--cross-prefix=$TOOL_CHAIN_PREFIX \
    --extra-cflags="$ECFLAGS" \
    --extra-cxxflags="$ECXXFLAGS" \
    --extra-ldflags="$ELDFLAGS" \
    --enable-avresample \
    --disable-debug \
    --disable-network \
    --disable-static \
    --enable-pic    \
    --enable-shared 
    
}

build()
{
    configure
    cd ${ffmpeg_root_path}
    make clean
    make -j2
    make install
}

build
