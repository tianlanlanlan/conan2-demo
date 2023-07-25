#!/bin/sh
set -e

check_cmake() {
  [ -z $(command -v cmake) ] && echo "cmake not installed" && exit 1
  cmake_minimum_version="3.24.4"
  cmake_current_version=$(cmake --version | grep -Po '(\d+\.)+\d+')
  version=$(printf "$cmake_minimum_version\n$cmake_current_version\n" | sort -V | head -n 1)
  # echo "cmake_current_version: '$cmake_current_version'"
  # echo "version: '$version'"
  if [ "$version" != "$cmake_minimum_version" ]; then
    printf "require cmake >= $cmake_minimum_version, current: $cmake_current_version\n"
    exit 1
  fi
  exit 0
}

check_cmake

rm -rf build
generators="Unix Makefiles" # "Unix Makefiles" | "Ninja"
cmake -B build -S . -G "$generators" \
  -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=cmake/conan_provider.cmake \
  -DCMAKE_CONFIGURATION_TYPES=ON \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build build -j 8
