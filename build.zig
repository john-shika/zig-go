const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib_mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    // register imports
    exe_mod.addImport("app_lib", lib_mod);

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "app",
        .root_module = lib_mod,
    });

    b.installArtifact(lib);

    const lib_dyn = b.addLibrary(.{
        .linkage = .dynamic,
        .name = "app",
        .root_module = lib_mod,
    });

    b.installArtifact(lib_dyn);

    const exe = b.addExecutable(.{
        .name = "app",
        .root_module = exe_mod,
    });

    b.installArtifact(exe);

    // add relative path
    exe.addRPath(b.path("."));

    // add include path
    exe.addIncludePath(b.path("."));
    exe.addIncludePath(b.path("src"));
    exe.addIncludePath(b.path("include"));

    if (target.result.os.tag == .windows) {
        exe.addIncludePath(b.path("include/win32"));
    }

    // add library path
    exe.addLibraryPath(b.path("."));
    exe.addLibraryPath(b.path("src"));
    exe.addLibraryPath(b.path("build"));
    exe.addLibraryPath(b.path("lib"));

    if (target.result.os.tag == .windows) {
        exe.addLibraryPath(b.path("lib/win32"));
    }

    // linking library
    exe.linkSystemLibrary("loader");

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .root_module = exe_mod,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const lib_unit_tests = b.addTest(.{
        .root_module = lib_mod,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
    test_step.dependOn(&run_lib_unit_tests.step);
}
