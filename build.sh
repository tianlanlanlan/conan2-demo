#!/bin/sh
set -e
# set -x

platform_options="<linux | riscv | arm>"
recommand_conan_version="2.0.6"

check_conan() {
  [ -z $(command -v conan) ] && echo "conan not installed" && exit 1
  if [ ! $(conan --version | grep -o '[0-9.]*') -eq "$conan_version" ]; then
    pip install conan==$conan_version --upgrade
  fi
}

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
  # --format json >$build_dir/conan_install_output.json

# Debug | RelWithDebInfo | MinSizeRel | Release
build_type="RelWithDebInfo"

# cmake_preset_prefix=$platform
# cmake_preset_suffix=$(echo $build_type | awk '{print tolower($0)}')
# cmake_preset="$cmake_preset_prefix-$cmake_preset_suffix"
# cmake --preset $cmake_preset --log-level=VERBOSE
# cmake --build --preset $cmake_preset

cmake -S . -B $build_dir \
  -DCMAKE_TOOLCHAIN_FILE=$build_dir/conan/conan_toolchain.cmake \
  -DCMAKE_BUILD_TYPE=$build_type \
  # --log-level=VERBOSE
cmake --build $build_dir

# post process
case $platform in
linux)
  ldd ./$build_dir/bin/main
  ./$build_dir/bin/main
  ;;
riscv) ;;
arm) ;;
*) ;;
esac
