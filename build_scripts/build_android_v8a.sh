#/bin/sh
ffmpeg_root_path=$(dirname $(readlink -f $0))/..
echo "当前脚本所在父目录为：${ffmpeg_root_path}"
HOST=aarch64-linux-android
# bulid x264-stable
{
sh ${ffmpeg_root_path}/3rdpartys/x264-stable/build_scripts/build_android_v8a.sh
X264_PATH=${ffmpeg_root_path}/3rdpartys/x264-stable/install/${HOST}-x264-stable
X264_LIB=$X264_PATH/lib
X264_HEADER=$X264_PATH/include
}
# 172.20.31.106/172.20.191.53
NDK_ROOT=/data/wensha2/tool/android-ndk-r16b
TARGET_OS=android
ARCH=arm64
CPU=armv8-a
PREFIX=${ffmpeg_root_path}/install/${HOST}-ffmpeg4.2.9
# PREFIX=/data/wensha2/tool/ffmpeg4.2.9/install/${HOST}-ffmpeg4.2.9

TOOL_CHAIN_PREFIX=${NDK_ROOT}/toolchains/${HOST}-4.9/prebuilt/linux-x86_64/bin/${HOST}-
# <23 not support stderr
ANDROID_API=23
ECFLAGS="-isysroot $NDK_ROOT/sysroot -isystem $NDK_ROOT/sysroot/usr/include/${HOST} -I${X264_HEADER}                \
        -D__ANDROID_API__=${ANDROID_API} -DANDROID -march=${CPU} -fPIC"
ECXXFLAGS="${ECFLAGS} -std=c++11"
ELDFLAGS="-Wl,-z,noexecstack,-z,relro,-z,now -L${X264_LIB} -lc"     

configure()
{
    cd ${ffmpeg_root_path}
    ./configure \
    --disable-asm \
    --prefix=$PREFIX \
    --enable-cross-compile \
    --target-os=$TARGET_OS \
    --arch=$ARCH \
	--cross-prefix=$TOOL_CHAIN_PREFIX \
    --sysroot=${NDK_ROOT}/platforms/android-${ANDROID_API}/arch-${ARCH} \
    --extra-cflags="$ECFLAGS" \
    --extra-cxxflags="$ECXXFLAGS" \
    --extra-ldflags="$ELDFLAGS" \
    --enable-avresample \
    --disable-debug \
    --enable-pic    \
    --disable-network  
}

build()
{
    configure
    cd ${ffmpeg_root_path}
    make clean
    make -j
    make install
}

build
