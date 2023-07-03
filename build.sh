#!/bin/sh
set -e
# set -x

platform_options="<linux | riscv | arm>"

check_conan() {
  [ -z $(command -v conan) ] && echo "conan not installed" && exit 1
  conan_minimum_version="2.0.6"
  conan_current_version=$(conan --version | grep -o '[0-9.]*')
  version=$(printf "$conan_minimum_version\n$conan_current_version\n" | sort -V | head -n 1)
  if [ "$version" != "$conan_minimum_version" ]; then
    printf "require conan >= $conan_minimum_version, current: $conan_current_version\n"
    printf "run: 'pip install conan --upgrade'\n"
    exit 1
  fi
}

check_conan

usage() {
  printf "usage:\n\t$0 $platform_options\n"
  exit 1
}

[ ! $# -eq 1 ] && usage || platform=$1
case $platform in
linux)
  host_profile="./profiles/linux"
  ;;
riscv)
  host_profile="./profiles/riscv"
  ;;
arm)
  host_profile="./profiles/raspberry"
  ;;
*)
  echo "unkown '$platform', use $platform_options"
  exit 1
  ;;
esac

build_dir="build_$platform"
# Debug | RelWithDebInfo | MinSizeRel | Release
build_type="RelWithDebInfo"

[ -d hello_package ] && conan create hello_package

rm -rf $build_dir && mkdir $build_dir
conan install conanfile.py \
  --output-folder $build_dir \
  --profile $host_profile \
  --options *:shared=True \
  --options *:platform=$platform \
  --build missing \
  --settings build_type=Release \
  --settings protobuf/*:build_type=Debug \
  --settings fmt/*:build_type=Debug \
  --settings hello_package/*:build_type=Debug \
  --settings conan2_demo/*:build_type=$build_type \
  --format json >$build_dir/conan_install_output.json

# cmake_preset_prefix=$platform
# cmake_preset_suffix=$(echo $build_type | awk '{print tolower($0)}')
# cmake_preset="$cmake_preset_prefix-$cmake_preset_suffix"
# cmake --preset $cmake_preset --log-level=VERBOSE
# cmake --build --preset $cmake_preset

cmake -S . -B $build_dir \
  -DCMAKE_TOOLCHAIN_FILE=$build_dir/conan/conan_toolchain.cmake \
  -DCMAKE_BUILD_TYPE=$build_type \
  --log-level=VERBOSE
cmake --build $build_dir

# post process
case $platform in
linux)
  conan list hello_package/*:*
  ldd ./$build_dir/bin/main
  ./$build_dir/bin/main
  ;;
riscv) ;;
arm) ;;
*) ;;
esac
