#pragma once

#ifdef _WIN32
  #define HELLO_PACKAGE_EXPORT __declspec(dllexport)
#else
  #define HELLO_PACKAGE_EXPORT
#endif

HELLO_PACKAGE_EXPORT void world();
