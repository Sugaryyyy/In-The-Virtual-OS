tar -xf sed-4.9.tar.xz
cd sed-4.9

./configure --prefix=/usr   \
            --host=$LFS_TGT

make

make DESTDIR=$LFS install

rm -rf $LFS/sources/sed-4.9