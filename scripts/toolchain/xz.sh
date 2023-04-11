tar -xf xz-5.4.1.tar.xz
cd xz-5.4.1

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.4.1

make

make DESTDIR=$LFS install

rm -v $LFS/usr/lib/liblzma.la

rm -rf $LFS/sources/xz-5.4.1