const std = @import("std");
const builtin = @import("builtin");

const c = @cImport({
    if (isWin()) @cDefine("LOADER_WIN32_SHARED", "1");
    @cInclude("loader.h");
});

fn isWin() bool {
    return builtin.os.tag == .windows;
}

pub fn main() void {
    {
        const libsum_name: [*c]const u8 = comptime if (isWin()) "sum.dll" else "libsum.so";
        const libsum = c.open_library(libsum_name);
        if (libsum == null) {
            std.debug.print("Failed to load {s}\n", .{libsum_name});
            return;
        }
        defer c.close_library(libsum);

        const sum_func = c.create_sum_function(libsum);
        if (sum_func == null) {
            std.debug.print("Failed to create sum function\n", .{});
            return;
        }

        const sum_result = sum_func.?(2, 3);
        std.debug.print("Sum: {}\n", .{sum_result});
    }

    {
        const libmultiply_name: [*c]const u8 = comptime if (isWin()) "multiply.dll" else "libmultiply.so";
        const libmultiply = c.open_library(libmultiply_name);
        if (libmultiply == null) {
            std.debug.print("Failed to load {s}\n", .{libmultiply_name});
            return;
        }
        defer c.close_library(libmultiply);

        const multiply_func = c.create_multiply_function(libmultiply);
        if (multiply_func == null) {
            std.debug.print("Failed to create sum function\n", .{});
            return;
        }

        const multiply_result = multiply_func.?(2, 3);
        std.debug.print("Multiply: {}\n", .{multiply_result});
    }
}
