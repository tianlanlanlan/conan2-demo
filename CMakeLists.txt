cmake_minimum_required(VERSION 3.22.5)

project(Conan2Demo LANGUAGES CXX C)

include(cmake/utils.cmake)

# set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    message(STATUS "Setting default CMAKE_INSTALL_PREFIX path to ${CMAKE_SOURCE_DIR}/output")
    set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/output" CACHE STRING "The path to use for make install" FORCE)
endif()

# main exe
add_executable(main src/main.cpp)
target_link_libraries(main
    PRIVATE
    fmt::fmt
    ZLIB::ZLIB
    protobuf::libprotobuf
    protobuf::libprotoc
    hello_package::hello
    hello_package::world
)
install(TARGETS main RUNTIME DESTINATION bin)

# demo lib
add_library(demo SHARED src/demo.c)
set(DEMO_VERSION_MAJOR 1)
set(DEMO_VERSION_MINOR 2)
set(DEMO_VERSION_PATCH 3)
set(DEMO_VERSION
    ${DEMO_VERSION_MAJOR}.${DEMO_VERSION_MINOR}.${DEMO_VERSION_PATCH})
set_target_properties(demo
    PROPERTIES
    VERSION ${DEMO_VERSION}
    SOVERSION ${DEMO_VERSION_MAJOR}
)
install(TARGETS demo LIBRARY DESTINATION lib)
