#/bin/sh
ffmpeg_root_path=$(dirname $(readlink -f $0))/..
echo "当前脚本所在父目录为：${ffmpeg_root_path}"

ARCH=aarch64
# bulid x264-stable
# {
sh ${ffmpeg_root_path}/3rdpartys/x264-stable/build_scripts/build_aarch64_linux.sh
X264_PATH=${ffmpeg_root_path}/3rdpartys/x264-stable/install/${ARCH}-linux-x264-stable
X264_LIB=$X264_PATH/lib
X264_HEADER=$X264_PATH/include
# }

TARGET_OS=linux

# CPU=${ARCH}
CPU=armv8-a
# PREFIX=${ffmpeg_root_path}/install/${ARCH}-linux-ffmpeg4.2.9
# PREFIX=/data/wensha2/tool/ffmpeg4.2.9/install/${ARCH}-linux-ffmpeg4.2.9
PREFIX=/home/wensha2/workspace/opt/ffmpeg4.2.9/install/${ARCH}-linux-ffmpeg4.2.9

TOOL_CHAIN_PREFIX=/data/wensha2/tool/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin/${ARCH}-linux-gnu-

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
    --enable-pic
    
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
