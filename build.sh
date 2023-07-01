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

[ $# -eq 1 ] && platform=$1 || platform="linux"
case $platform in
linux)
  host_profile="./profiles/default"
  ;;
riscv)
  host_profile="./profiles/riscv"
  ;;
arm)
  host_profile="./profiles/raspberry"
  ;;
*)
  echo "unkown '$platform', use $platform_options"
  usage
  ;;
esac

# Debug | RelWithDebInfo | MinSizeRel | Release
build_type="Debug"
cmake_preset_prefix=$platform
cmake_preset_suffix=$(echo $build_type | awk '{print tolower($0)}')
cmake_preset="$cmake_preset_prefix-$cmake_preset_suffix"
build_dir="build_$platform"

rm -rf $build_dir
conan install conanfile.py \
  --output-folder $build_dir \
  --profile $host_profile \
  --settings build_type=$build_type \
  --options *:shared=True \
  --options *:platform=$platform \
  --build missing
cmake --preset $cmake_preset --log-level=VERBOSE
cmake --build --preset $cmake_preset

# post process
case $platform in
linux)
  ./$build_dir/bin/main
  ;;
riscv) ;;
arm) ;;
*) ;;
esac
