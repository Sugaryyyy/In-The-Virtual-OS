#!/bin/bash
set -e

if [ -z "$LFS" ]; then
echo "[*]\$LFS is not defined or NULL, setting it up for you"
export LFS=$(pwd)/build_env/build_root/
fi

if [ -z "$DIST_ROOT" ]; then
echo "[*]\$DIST_ROOT is not defined or NULL, setting it up for you"
export DIST_ROOT=$(pwd)
fi

echo "Dist Root: ${DIST_ROOT:?}"
echo "LFS: ${LFS:?}"

echo "Running script as user LFS (part2)"
echo $LFS
echo $DIST_ROOT

cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=$LFS
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
EOF

as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo -S $*
  else                            su -c \\"$*\\"
  fi
}

[ ! -e /etc/bash.bashrc ] || as_root mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE

export MAKEFLAGS="-j$(nproc)"
echo $MAKEFLAGS

set +h
umask 022
LFS=$LFS
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE

echo "Dist Root: ${DIST_ROOT:?}"
echo "LFS: ${LFS:?}"
cd $DIST_ROOT
pwd
ls
cd build_env/build_root/sources/
echo "Compiling"

bash -e $DIST_ROOT/scripts/toolchain/binutils1.sh
bash -e $DIST_ROOT/scripts/toolchain/gcc1.sh
bash -e $DIST_ROOT/scripts/toolchain/linux-headers.sh
bash -e $DIST_ROOT/scripts/toolchain/glibc.sh
bash -e $DIST_ROOT/scripts/toolchain/libstdcpp.sh 
bash -e $DIST_ROOT/scripts/toolchain/m4.sh 
bash -e $DIST_ROOT/scripts/toolchain/ncurses.sh 
bash -e $DIST_ROOT/scripts/toolchain/bash.sh 
bash -e $DIST_ROOT/scripts/toolchain/coreutils.sh 
bash -e $DIST_ROOT/scripts/toolchain/diffutils.sh 
bash -e $DIST_ROOT/scripts/toolchain/file.sh 
bash -e $DIST_ROOT/scripts/toolchain/findutils.sh 
bash -e $DIST_ROOT/scripts/toolchain/gawk.sh 
bash -e $DIST_ROOT/scripts/toolchain/grep.sh 
bash -e $DIST_ROOT/scripts/toolchain/gzip.sh 
bash -e $DIST_ROOT/scripts/toolchain/make.sh 
bash -e $DIST_ROOT/scripts/toolchain/patch.sh 
bash -e $DIST_ROOT/scripts/toolchain/sed.sh 
bash -e $DIST_ROOT/scripts/toolchain/tar.sh 
bash -e $DIST_ROOT/scripts/toolchain/xz.sh 
bash -e $DIST_ROOT/scripts/toolchain/binutils2.sh 


