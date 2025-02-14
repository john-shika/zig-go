#ifndef LOADER_H
#define LOADER_H

#include <dlfcn.h>

#ifdef LOADER_WIN32
#ifdef LOADER_WIN32_EXPORTS
#define DLLEXPORT __declspec(dllexport)
#else
#define DLLEXPORT __declspec(dllimport)
#endif
#else
#define DLLEXPORT
#endif

typedef int (*sum_func)(int, int);
typedef int (*multiply_func)(int, int);

DLLEXPORT void *load_library(const char *path);
DLLEXPORT void close_library(void *handle);
DLLEXPORT sum_func load_sum_function(void *handle);
DLLEXPORT multiply_func load_multiply_function(void *handle);

#endif // LOADER_H
