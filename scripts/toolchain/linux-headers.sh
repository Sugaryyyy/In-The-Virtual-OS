tar -xf linux-6.1.11.tar.xz
cd linux-6.1.11

make mrproper

make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr

rm -rf $LFS/sources/linux-6.1.11