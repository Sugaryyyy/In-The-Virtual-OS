tar -xf grep-3.8.tar.xz
cd grep-3.8

./configure --prefix=/usr   \
            --host=$LFS_TGT

make

make DESTDIR=$LFS install

rm -rf $LFS/sources/grep-3.8