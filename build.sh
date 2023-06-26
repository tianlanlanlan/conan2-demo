#!/bin/sh
set -e
# set -x

platform_options="<linux | riscv | arm>"
recommand_conan_version="2.0.6"

if [ $# -ne 1 ]; then
  printf "usage:\n\t$0 $platform_options\n"
  exit 1
fi

check_conan() {
  [ -z $(command -v conan) ] && echo "conan not installed" && exit 1
  if [ ! $(conan --version | grep -o '[0-9.]*') -eq "$conan_version" ]; then
    pip install --force-reinstall -v conan==$conan_version
  fi
}

# check_conan

platform=$1
case $platform in
linux)
  host_profile="default"
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

# Debug | RelWithDebInfo | MinSizeRel | Release
build_type="RelWithDebInfo"
cmake_preset_prefix=$platform
cmake_preset_suffix=$(echo $build_type | awk '{print tolower($0)}')
cmake_preset="$cmake_preset_prefix-$cmake_preset_suffix"
build_dir="build_$platform"

rm -rf $build_dir && mkdir $build_dir
conan install conanfile.py \
  --output-folder $build_dir \
  --profile $host_profile \
  --settings build_type=$build_type \
  --options *:platform=$platform \
  --options *:shared=True \
  --build missing
cmake --preset $cmake_preset --log-level=VERBOSE
cmake --build --preset $cmake_preset
