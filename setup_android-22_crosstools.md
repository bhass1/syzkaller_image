
# Setup Android Cross-Tools

```
wget http://dl.google.com/android/repository/android-ndk-r12b-linux-x86_64.zip
unzip android-ndk-r12b-linux-x86_64.zip 
cd android-ndk-r12b/
./build/tools/make_standalone_toolchain.py --arch arm --api 22 --install-dir=/opt/androidndk-22-arm-toolchain
export PATH=$PATH:/opt/androidndk-22-arm-toolchain/bin
target_host=arm-linux-androideabi
export AR=$target_host-ar
export AS=$target_host-clang
export CC=$target_host-clang
export CXX=$target_host-clang++
export LD=$target_host-ld
export STRIP=$target_host-strip
export CFLAGS="-fPIE -fPIC"
export LDFLAGS="-pie"
```



# Compile GDB(x86 64)  & GDB Server(arm-linux-androideabi)

From https://sourceware.org/gdb/wiki/BuildingCrossGDBandGDBserver

## Prerequisite

 1) Must do `Setup Android Cross-Tools` first. 

## Steps

### GDB Server (host=arm-linux-androideabi)

```
git clone git://sourceware.org/git/binutils-gdb.git

cd binutils-gdb
git checkout gdb-7.7-branch

mkdir gdb/gdbserver/gdbserver-build

cd gdb/gdbserver/gdbserver-build
../configure --host=arm-linux-androideabi
make -j16
```

After build, gdbserver located in current (make) directory

### GDB (host=x86 64)

cd $OLDPWD
mkdir gdb-build

cd gdb-build
../configure --target=arm-linux-androideabi
make -j 16
```

After build, gdb located in ./gdb/ directory


# Compile GDB(host=arm-linux-androideabi)

## Prerequisite

 1) Must do `1. Setup Android Cross-Tools` first. 
 2) Compile GDB dependency libtermcap.a(host=arm-linux-androideabi)

### Compile GDB dependency libtermcap.a(host=arm-linux-androideabi)

```
wget https://ftp.gnu.org/gnu/termcap/termcap-1.3.1.tar.gz
tar xzvf termcap-1.3.1.tar.gz 
cd termcap-1.3.1/
mkdir termcap-build
cd termcap-build/
../configure --host=arm-linux-androideabi
```

Now edit Makefile:

```
-24 CC = gcc
-25 AR = ar
-26 RANLIB = ranlib
+24 CC = arm-linux-androideabi-gcc
+25 AR = arm-linux-androideabi-ar
+26 RANLIB = arm-linux-androideabi-ranlib
```

Make it:

```
make -j 16
```

libtermcap.a located in current directory

## Steps to Compile GDB(host=arm-linux-androideabi)

Copy libtermcap.a & headers to ndk-22 toolchain.

```
cp libtermcap.a /opt/androidndk-22-arm-toolchain/arm-linux-androideabi/lib/.
mkdir /opt/androidndk-22-arm-toolchain/arm-linux-androideabi/include/
cp termcap.h /opt/androidndk-22-arm-toolchain/arm-linux-androideabi/include/.
```

Get gdb sources.

```
git clone git://sourceware.org/git/binutils-gdb.git

cd binutils-gdb
git checkout gdb-7.7-branch

mkdir gdb-arm-build
```

Apply gdb patch. 
From: https://blog.csdn.net/xiaolli/article/details/52650036

```
cd gdb
git am --3way 0001-Patches-to-build-gdb-against-host-arm-linux-androide.patch
```

Now go build it!
_*Note:*_ You will still get a compile error, but it occurs after gdb is built!

```
cd ../gdb-arm-build
../configure --host=arm-linux-gnueabi
make -j 16
```

_*Note:*_ You will still get a compile error, but it occurs after gdb is built!

