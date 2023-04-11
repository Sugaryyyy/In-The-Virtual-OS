#!/bin/bash
set -e

as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}

export -f as_root

echo "It starts with setting up the variables." 

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

as_root chmod -R 777 $DIST_ROOT

echo "Checking for host system tools"

export LC_ALL=C
bash --version | head -n1 | cut -d" " -f2-4
MYSH=$(readlink -f /bin/sh)
echo "/bin/sh -> $MYSH"
echo $MYSH | grep -q bash || echo "ERROR: /bin/sh does not point to bash"
unset MYSH

echo -n "Binutils: "; ld --version | head -n1 | cut -d" " -f3-
bison --version | head -n1

if [ -h /usr/bin/yacc ]; then
  echo "/usr/bin/yacc -> `readlink -f /usr/bin/yacc`";
elif [ -x /usr/bin/yacc ]; then
  echo yacc is `/usr/bin/yacc --version | head -n1`
else
  echo "yacc not found"
fi

echo -n "Coreutils: "; chown --version | head -n1 | cut -d")" -f2
diff --version | head -n1
find --version | head -n1
gawk --version | head -n1

if [ -h /usr/bin/awk ]; then
  echo "/usr/bin/awk -> `readlink -f /usr/bin/awk`";
elif [ -x /usr/bin/awk ]; then
  echo awk is `/usr/bin/awk --version | head -n1`
else
  echo "awk not found"
fi

gcc --version | head -n1
g++ --version | head -n1
grep --version | head -n1
gzip --version | head -n1
cat /proc/version
m4 --version | head -n1
make --version | head -n1
patch --version | head -n1
echo Perl `perl -V:version`
python3 --version
sed --version | head -n1
tar --version | head -n1
makeinfo --version | head -n1  # texinfo version
xz --version | head -n1


echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
if [ -x dummy ]
  then echo "g++ compilation OK";
  else echo "g++ compilation failed"; fi
rm -f dummy.c dummy

mkdir -v -p $LFS/sources

as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}

as_root chmod -v a+wt $LFS/sources

cd $LFS
wget -nc https://www.linuxfromscratch.org/lfs/view/stable/wget-list-sysv 
wget --input-file=wget-list-sysv --continue -nc --directory-prefix=$LFS/sources
wget -nc https://www.linuxfromscratch.org/lfs/view/stable/md5sums --directory-prefix=$LFS/sources
pushd $LFS/sources
  md5sum -c md5sums
popd

as_root chown root:root $LFS/sources/*

as_root mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  as_root ln -svf usr/$i $LFS/$i
done

case $(uname -m) in
  x86_64) as_root mkdir -pv $LFS/lib64 ;;
esac

as_root mkdir -pv $LFS/tools
as_root usermod -aG sudo lfs
as_root groupadd -f lfs
as_root id -u lfs &>/dev/null || useradd -s /bin/bash -g lfs -m -k /dev/null lfs
as_root passwd lfs
as_root chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) as_root chown -v lfs $LFS/lib64 ;;
esac
cd $DIST_ROOT
as_root chmod +x scripts/part2.sh

as_root su lfs --session-command ./scripts/part2.sh