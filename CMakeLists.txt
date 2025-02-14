cmake_minimum_required(VERSION 3.10)
project(loader)

# Detect the OS and set appropriate file extension
if (WIN32)
    # add_subdirectory(dlfcn-win32)
    include_directories(include/win32)
    link_directories(lib/win32)
    set(OUTPUT_NAME loader)
    set(DL_EXT dll)
else()
    set(OUTPUT_NAME libloader)
    set(DL_EXT so)
endif()

# Add subdirectories for each Go library
add_subdirectory(sum)
add_subdirectory(multiply)

# C library (loader)
add_library(loader SHARED loader.c)
target_link_libraries(loader dl)
set_target_properties(loader PROPERTIES OUTPUT_NAME ${OUTPUT_NAME})

if (WIN32)
    if (BUILD_SHARED_LIBS)
        target_compile_definitions(loader PRIVATE LOADER_WIN32_SHARED)
    endif()

    target_compile_definitions(loader PRIVATE LOADER_WIN32_EXPORTS)
    target_compile_definitions(loader PRIVATE LOADER_WIN32)
endif()

# Ensure Go libraries are built before building loader
add_dependencies(loader build_sum_lib build_multiply_lib)

