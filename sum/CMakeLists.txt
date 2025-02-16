cmake_minimum_required(VERSION 3.10)
project(sum)

# Set shared library extension and name based on the platform
if (WIN32)
    set(LIB_NAME sum)
    set(DL_EXT dll)
else()
    set(LIB_NAME libsum)
    set(DL_EXT so)
endif()

# Set CGO flags for linking dynamic
set(ENV{CGO_LDFLAGS} "-Wl,-rpath,.")

# Go build command for the shared library
add_custom_command(
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMAND go build -o ${CMAKE_CURRENT_BINARY_DIR}/${LIB_NAME}.${DL_EXT} -buildmode=c-shared main.go
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${LIB_NAME}.${DL_EXT}
    COMMENT "Building ${LIB_NAME}.${DL_EXT}"
)

# Add custom target for the shared library
add_custom_target(build_sum_lib ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${LIB_NAME}.${DL_EXT})
