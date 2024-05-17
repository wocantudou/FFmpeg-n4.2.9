#/bin/sh
ffmpeg_root_path=$(dirname $(readlink -f $0))/..
echo "当前脚本所在父目录为：${ffmpeg_root_path}"

ARCH=x86_64
# bulid x264-stable
# {
sh ${ffmpeg_root_path}/3rdpartys/x264-stable/build_scripts/build_intellinux64.sh
X264_PATH=${ffmpeg_root_path}/3rdpartys/x264-stable/install/${ARCH}-intellinux64-x264-stable
X264_LIB=$X264_PATH/lib
X264_HEADER=$X264_PATH/include
# }

TARGET_OS=x86_64
CPU=${ARCH}

# PREFIX=${ffmpeg_root_path}/install/${ARCH}-intellinux64-ffmpeg4.2.9
# PREFIX=/data/wensha2/tool/ffmpeg4.2.9/install/${ARCH}-intellinux64-ffmpeg4.2.9
PREFIX=/home/wensha2/workspace/opt/ffmpeg4.2.9/install/${ARCH}-intellinux64-ffmpeg4.2.9

ECFLAGS="-I${X264_HEADER}"
# ECXXFLAGS="-std=c++11 -fPIC -I${X264_HEADER}"
ECXXFLAGS="${ECFLAGS} -std=c++11"
ELDFLAGS="-L${X264_LIB}"

configure()
{
    cd ${ffmpeg_root_path}
    ./configure \
    --prefix=$PREFIX \
    --arch=$ARCH \
    --extra-cflags="$ECFLAGS" \
    --extra-cxxflags="$ECXXFLAGS" \
    --extra-ldflags="$ELDFLAGS" \
    --disable-x86asm \
    --enable-avresample \
    --disable-debug \
    --enable-pic    \
    --disable-asm   \
    --disable-network 
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

