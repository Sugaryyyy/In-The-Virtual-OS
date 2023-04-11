echo "Dist Root: ${DIST_ROOT:?}"
echo "LFS: ${LFS:?}"

tar -xf binutils-2.40.tar.xz
cd binutils-2.40

mkdir -vp build
cd       build

../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror

make

make install
rm -rf $LFS/sources/binutils-2.40
