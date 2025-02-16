cmake_minimum_required(VERSION 3.10)
project(loader)

# Detect the OS and set appropriate file extension
if (WIN32)
    # add_subdirectory(dlfcn-win32)
    include_directories(include/win32)
    link_directories(lib/win32)
    set(DL_EXT dll)
else()
    set(DL_EXT so)
endif()

# Add subdirectories for each Go library
add_subdirectory(sum)
add_subdirectory(multiply)

# C library (loader)
add_library(loader SHARED src/loader.c)
target_link_libraries(loader dl)

# Add relative path
set_target_properties(loader PROPERTIES
    INSTALL_RPATH_USE_LINK_PATH TRUE
    INSTALL_RPATH "."
)

if (WIN32)
    if (BUILD_SHARED_LIBS)
        target_compile_definitions(loader PRIVATE LOADER_WIN32_SHARED)
    endif()

    target_compile_definitions(loader PRIVATE LOADER_WIN32_EXPORTS)
    target_compile_definitions(loader PRIVATE LOADER_WIN32)
endif()

# Ensure Go libraries are built before building loader
add_dependencies(loader build_sum_lib build_multiply_lib)

