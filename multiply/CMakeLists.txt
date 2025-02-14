cmake_minimum_required(VERSION 3.10)
project(multiply)

# Set shared library extension and name based on the platform
if (WIN32)
    set(LIB_NAME multiply)
    set(DL_EXT dll)
else()
    set(LIB_NAME libmultiply)
    set(DL_EXT so)
endif()

# Go build command for the shared library
add_custom_command(
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMAND go build -o ${CMAKE_CURRENT_BINARY_DIR}/${LIB_NAME}.${DL_EXT} -buildmode=c-shared main.go
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${LIB_NAME}.${DL_EXT}
    COMMENT "Building ${LIB_NAME}.${DL_EXT}"
)

# Add custom target for the shared library
add_custom_target(build_multiply_lib ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${LIB_NAME}.${DL_EXT})
