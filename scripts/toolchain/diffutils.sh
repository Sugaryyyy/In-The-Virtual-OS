tar -xf diffutils-3.9.tar.xz
cd diffutils-3.9

./configure --prefix=/usr --host=$LFS_TGT
make
make DESTDIR=$LFS install

rm -rf $LFS/sources/diffutils-3.9