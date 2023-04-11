tar -xf gawk-5.2.1.tar.xz
cd gawk-5.2.1

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

rm -rf $LFS/sources/gawk-5.2.1