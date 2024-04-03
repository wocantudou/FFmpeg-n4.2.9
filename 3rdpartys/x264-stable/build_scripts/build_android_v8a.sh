#/bin/sh
# https://blog.51cto.com/u_13861442/5169958
x264_root_path=$(dirname $(readlink -f $0))/..
echo "当前脚本所在父目录为：${x264_root_path}"

# 172.20.191.53
NDK_ROOT=/data/wensha2/tool/android-ndk-r16b
ARCH=arm64
CPU=armv8-a
HOST=aarch64-linux-android
PREFIX=${x264_root_path}/install/${HOST}-x264-stable
TOOL_CHAIN_PREFIX=${NDK_ROOT}/toolchains/${HOST}-4.9/prebuilt/linux-x86_64/bin/${HOST}-

ANDROID_API=21

ECFLAGS="-isysroot $NDK_ROOT/sysroot -isystem $NDK_ROOT/sysroot/usr/include/aarch64-linux-android        \
        -D__ANDROID_API__=${ANDROID_API}  -DANDROID -march=${CPU} -fPIC"
        
ELDFLAGS="-Wl,-z,noexecstack,-z,relro,-z,now"     

configure()
{
    cd ${x264_root_path}
    ./configure \
    --disable-asm \
    --prefix=$PREFIX \
    --cross-prefix=$TOOL_CHAIN_PREFIX \
    --sysroot=${NDK_ROOT}/platforms/android-${ANDROID_API}/arch-${ARCH} \
    --host=$HOST \
    --extra-cflags="$ECFLAGS" \
    --extra-ldflags="$ELDFLAGS" \
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

