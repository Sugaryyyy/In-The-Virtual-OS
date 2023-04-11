tar -xf gzip-1.12.tar.xz
cd gzip-1.12

./configure --prefix=/usr --host=$LFS_TGT

make

make DESTDIR=$LFS install

rm -rf $LFS/sources/gzip-1.12