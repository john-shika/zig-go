import os
import platform
import shutil
import subprocess
import requests

ROOT_DIR = "."
BUILD_DIR = "build"

def is_win():
    return platform.system().lower().startswith('win')

def dlfcn_win32_gitfetch():
    try:
        url = "https://github.com/dlfcn-win32/dlfcn-win32.git"
        clone_dir = os.path.join(ROOT_DIR, "dlfcn-win32")

        print(f"Cloning {url} into {clone_dir} ...")
        subprocess.run(["git", "clone", url, clone_dir], check=True)

        print("Clone complete.")
    
    except Exception as e:
        print(f"Error cloning dlfcn-win32: {e}")

def cmake_build():
    cmake_args = [
        "cmake",
        "-G", "Ninja",
        "-DCMAKE_C_COMPILER=clang",
        "-DCMAKE_CXX_COMPILER=clang++",
        "-S", ".",
        "-B", BUILD_DIR
    ]
    subprocess.run(cmake_args)
    subprocess.run(["cmake", "--build", BUILD_DIR])

def copy_libs():
    print("Copying shared libraries to the root directory...")
    if is_win():
        lib_prefix = ""
        dl_ext = "dll"
    else:
        lib_prefix = "lib"
        dl_ext = "so"
    
    output_path = os.path.join(ROOT_DIR, "out")
    os.makedirs(output_path, exist_ok=True)

    shutil.copy(os.path.join(BUILD_DIR, f"{lib_prefix}loader.{dl_ext}"), output_path)
    shutil.copy(os.path.join(BUILD_DIR, "sum", f"{lib_prefix}sum.{dl_ext}"), output_path)
    shutil.copy(os.path.join(BUILD_DIR, "multiply", f"{lib_prefix}multiply.{dl_ext}"), output_path)
    
    if is_win():
        # shutil.copy(os.path.join(BUILD_DIR, "bin", f"dl.{dl_ext}"), output_path)
        shutil.copy(os.path.join(ROOT_DIR, "lib/win32", f"dl.{dl_ext}"), output_path)
    
    zig_output_path = os.path.join(ROOT_DIR, "zig-out")
    
    if is_win():
        shutil.copy(os.path.join(zig_output_path, "bin/app.exe"), output_path)
        shutil.copy(os.path.join(zig_output_path, "bin/app.dll"), output_path)
        shutil.copy(os.path.join(zig_output_path, "bin/app.pdb"), output_path)
        shutil.copy(os.path.join(zig_output_path, "lib/app.lib"), output_path)
    
    else:
        shutil.copy(os.path.join(zig_output_path, "bin/app"), output_path)
        shutil.copy(os.path.join(zig_output_path, "lib/libapp.a"), output_path)
        shutil.copy(os.path.join(zig_output_path, "lib/libapp.so"), output_path)
    
    print("Shared libraries copied successfully.")

def zig_build():
    # dlfcn_win32_gitfetch()
    cmake_build()
    
    zig_args = ["zig", "build"]
    subprocess.run(zig_args)
    copy_libs()

if str(__name__).upper() in ("__MAIN__",):
    zig_build()
