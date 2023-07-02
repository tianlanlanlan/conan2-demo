cmake_minimum_required(VERSION 3.24.4 FATAL_ERROR)
include(cmake/utils.cmake)

project(Conan2Demo LANGUAGES CXX C)

# set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

find_package(fmt REQUIRED)
find_package(ZLIB REQUIRED)
find_package(protobuf REQUIRED)
print_target_properties(fmt::fmt)
print_target_properties(ZLIB::ZLIB)

add_executable(main src/main.cpp)
target_link_libraries(main PRIVATE fmt::fmt ZLIB::ZLIB)

add_library(demo SHARED src/demo.c)
set(DEMO_VERSION_MAJOR 1)
set(DEMO_VERSION_MINOR 2)
set(DEMO_VERSION_PATCH 3)
set(DEMO_VERSION
    ${DEMO_VERSION_MAJOR}.${DEMO_VERSION_MINOR}.${DEMO_VERSION_PATCH})
set_target_properties(demo PROPERTIES VERSION ${DEMO_VERSION}
    SOVERSION ${DEMO_VERSION_MAJOR})
