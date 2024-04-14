cmake_minimum_required(VERSION 3.15)
project(hello_package CXX)

set(VERSION_MAJOR 0)
set(VERSION_MINOR 1)
set(VERSION_PATCH 0)
set(HELLO_PACKAGE_VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})

add_library(hello src/hello.cpp)
target_include_directories(hello PUBLIC include)
set_target_properties(hello PROPERTIES
  PUBLIC_HEADER "include/hello.h"
  VERSION ${HELLO_PACKAGE_VERSION}
  SOVERSION ${VERSION_MAJOR}
  DEBUG_POSTFIX "d")
install(TARGETS hello)

add_library(world src/world.cpp)
target_include_directories(world PUBLIC include)
set_target_properties(world PROPERTIES
  PUBLIC_HEADER "include/world.h"
  VERSION ${HELLO_PACKAGE_VERSION}
  SOVERSION ${VERSION_MAJOR}
  DEBUG_POSTFIX "d")
install(TARGETS world)
