cmake_minimum_required(VERSION 3.15)
project(hello_package CXX)

add_library(hello src/hello.cpp)
target_include_directories(hello PUBLIC include)
set_target_properties(hello PROPERTIES
  PUBLIC_HEADER "include/hello.h"
  DEBUG_POSTFIX "d")
install(TARGETS hello)

add_library(world src/world.cpp)
target_include_directories(world PUBLIC include)
set_target_properties(world PROPERTIES
  PUBLIC_HEADER "include/world.h"
  DEBUG_POSTFIX "d")
install(TARGETS world)
