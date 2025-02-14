#include <stdio.h>
#include <stdlib.h>
#include "loader.h"

void *open_library(const char *path) {
    return dlopen(path, RTLD_LAZY);
}

void close_library(void *handle) {
    dlclose(handle);
}

sum_func create_sum_function(void *handle) {
    return (sum_func)dlsym(handle, "Sum");
}

multiply_func create_multiply_function(void *handle) {
    return (multiply_func)dlsym(handle, "Multiply");
}
