#!/bin/sh
set -e

rm -rf build
generators="Ninja" # "Unix Makefiles" | "Ninja"
cmake -B build -S . -G "$generators" \
  -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=cmake/conan_provider.cmake \
  -DCMAKE_CONFIGURATION_TYPES=ON \
  -DCMAKE_BUILD_TYPE=Debug
cmake --build build -j 8
