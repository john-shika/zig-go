#ifndef LOADER_H
#define LOADER_H

#include <dlfcn.h>

// windows import DLL (dynamic only)
#ifdef _WIN32
#define LOADER_WIN32_SHARED 1
#endif

#ifdef LOADER_WIN32_SHARED
#ifdef LOADER_WIN32_EXPORTS
#define LOADER_WIN32_EXPORT __declspec(dllexport)
#else
#define LOADER_WIN32_EXPORT __declspec(dllimport)
#endif
#else
#define LOADER_WIN32_EXPORT
#endif

typedef int (*sum_func)(int, int);
typedef int (*multiply_func)(int, int);

LOADER_WIN32_EXPORT void *open_library(const char *path);
LOADER_WIN32_EXPORT void close_library(void *handle);
LOADER_WIN32_EXPORT sum_func create_sum_function(void *handle);
LOADER_WIN32_EXPORT multiply_func create_multiply_function(void *handle);

#endif // LOADER_H
