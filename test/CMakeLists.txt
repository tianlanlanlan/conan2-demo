cmake_minimum_required(VERSION 3.5)

project(test)

add_library(example_google_test
    Reverse.cpp
    Palindrome.cpp
)

enable_testing()
find_package(GTest)

add_executable(unit_tests unit_tests.cpp)
target_link_libraries(unit_tests
    example_google_test
    gtest::gtest
)

include(GoogleTest)
gtest_discover_tests(unit_tests)