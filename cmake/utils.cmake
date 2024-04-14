include(CMakePrintHelpers)

# copy from https://stackoverflow.com/questions/32183975/how-to-print-all-the-properties-of-a-target-in-cmake
# Get all propreties that cmake supports
if(NOT CMAKE_PROPERTY_LIST)
  execute_process(COMMAND cmake --help-property-list
    OUTPUT_VARIABLE CMAKE_PROPERTY_LIST)

  # Convert command output into a CMake list
  string(REGEX REPLACE ";" "\\\\;" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
  string(REGEX REPLACE "\n" ";" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
  list(REMOVE_DUPLICATES CMAKE_PROPERTY_LIST)
endif()

function(print_properties)
  message("CMAKE_PROPERTY_LIST = ${CMAKE_PROPERTY_LIST}")
endfunction()

function(print_target_properties target)
  if(NOT TARGET ${target})
    message(STATUS "There is no target named '${target}'")
    return()
  endif()

  set(property_valid_list "")

  foreach(property ${CMAKE_PROPERTY_LIST})
    string(REPLACE "<CONFIG>" "${CMAKE_BUILD_TYPE}" property ${property})

    if(property STREQUAL "LOCATION" OR property MATCHES "^LOCATION_" OR property MATCHES "_LOCATION$")
      continue()
    endif()

    get_property(was_set TARGET ${target} PROPERTY ${property} SET)

    if(was_set)
      list(APPEND property_valid_list ${property})
    endif()
  endforeach()

  cmake_print_properties(TARGETS ${target} PROPERTIES ${property_valid_list})
endfunction()

# copy from https://stackoverflow.com/questions/18968979/how-to-make-colorized-message-with-cmake
if(NOT WIN32)
  string(ASCII 27 Esc)
  set(ColourReset "${Esc}[m")
  set(ColourBold "${Esc}[1m")
  set(Red "${Esc}[31m")
  set(Green "${Esc}[32m")
  set(Yellow "${Esc}[33m")
  set(Blue "${Esc}[34m")
  set(Magenta "${Esc}[35m")
  set(Cyan "${Esc}[36m")
  set(White "${Esc}[37m")
  set(BoldRed "${Esc}[1;31m")
  set(BoldGreen "${Esc}[1;32m")
  set(BoldYellow "${Esc}[1;33m")
  set(BoldBlue "${Esc}[1;34m")
  set(BoldMagenta "${Esc}[1;35m")
  set(BoldCyan "${Esc}[1;36m")
  set(BoldWhite "${Esc}[1;37m")
endif()

macro(print_find_package_generated_variables package_name)
  cmake_print_variables(${package_name}_VERSION)
  cmake_print_variables(${package_name}_FOUND)
  cmake_print_variables(${package_name}_INCLUDE_DIRS)
  cmake_print_variables(${package_name}_INCLUDE_DIR)
  cmake_print_variables(${package_name}_LIBRARIES)
  cmake_print_variables(${package_name}_DEFINITIONS)
  print_target_properties(${${package_name}_LIBRARIES})
endmacro()

message(STATUS "CMAKE_BUILD_TYPE: ${Green}${CMAKE_BUILD_TYPE}${ColourReset}")

find_package(fmt REQUIRED)
find_package(ZLIB REQUIRED)
find_package(protobuf REQUIRED)
find_package(hello_package REQUIRED)

# print_find_package_generated_variables(fmt)
# print_find_package_generated_variables(ZLIB)
# print_find_package_generated_variables(protobuf)
# print_find_package_generated_variables(hello_package)