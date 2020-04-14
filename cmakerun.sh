#!/bin/sh

# for armeabi-v7a and arm64-v8a cross compiling
toolchain_file="/media/shan/OS/Hiruna/temp-old/android-sdk-linux/ndk-bundle/build/cmake/android.toolchain.cmake"


#touch bcftoolsmisc.h
#echo "#include <sys/resource.h>
##include <sys/time.h>
#static inline double realtime(void) {
#    struct timeval tp;
#    struct timezone tzp;
#    gettimeofday(&tp, &tzp);
#    return tp.tv_sec + tp.tv_usec * 1e-6;
#}
#// taken from minimap2/misc
#static inline double cputime(void) {
#    struct rusage r;
#    getrusage(RUSAGE_SELF, &r);
#    return r.ru_utime.tv_sec + r.ru_stime.tv_sec +
#           1e-6 * (r.ru_utime.tv_usec + r.ru_stime.tv_usec);
#}
#//taken from minimap2
#static inline long peakrss(void)
#{
#    struct rusage r;
#    getrusage(RUSAGE_SELF, &r);
##ifdef __linux__
#    return r.ru_maxrss * 1024;
##else
#    return r.ru_maxrss;
##endif
#}" > src/nanopolishmisc.h

# to create a nanopolish library
cp main.c tempmain
sed -i ':a;N;$!ba;s/int main(int argc, char \*argv\[\])\n{/int init_bcftools(int argc, char *argv[])\n{/g' main.c
#sed -i 's+return ret;+fprintf(stderr,"[%s] Real time: %.3f sec; CPU time: %.3f sec; Peak RAM: %.3f GB\\n\\n",\n\t\t__func__, realtime() - realtime0, cputime(),peakrss() / 1024.0 / 1024.0 / 1024.0);\n\treturn ret;+g' src/main/nanopolish.cpp

touch interface.h
echo "int init_bcftools(int argc, char *argv[]);" > interface.h


mkdir -p build
rm -rf build
mkdir build
cd build

## for architecture x86
# cmake .. -DDEPLOY_PLATFORM=x86
# make -j 8

# # for architecture armeabi-V7a
#cmake .. -G Ninja -DCMAKE_TOOLCHAIN_FILE:STRING=$toolchain_file -DANDROID_PLATFORM=android-21 -DDEPLOY_PLATFORM:STRING="armeabi-v7a" -DANDROID_ABI="armeabi-v7a"
#ninja

 # for architecture arm64-v8a
 cmake .. -G Ninja -DCMAKE_TOOLCHAIN_FILE:STRING=$toolchain_file -DANDROID_PLATFORM=android-21 -DDEPLOY_PLATFORM:STRING="arm64-v8a" -DANDROID_ABI="arm64-v8a"
 ninja

cd ..
cp main.c aftermain
mv tempmain main.c
#echo "exiting..."