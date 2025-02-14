const std = @import("std");
const builtin = @import("builtin");

const c = @cImport(@cInclude("loader.h"));

fn isWin() bool {
    return builtin.os.tag == .windows;
}

pub fn main() void {
    const libsum_name: [*c]const u8 = if (isWin()) "sum.dll" else "libsum.so";
    const libsum = c.load_library(libsum_name);
    if (libsum == null) {
        std.debug.print("Failed to load {s}\n", .{libsum_name});
        return;
    }

    const sum = c.load_sum_function(libsum);
    const sum_result = sum.?(2, 3);
    std.debug.print("Sum: {}\n", .{sum_result});
    c.close_library(libsum);

    const libmultiply_name: [*c]const u8 = if (isWin()) "multiply.dll" else "libmultiply.so";
    const libmultiply = c.load_library(libmultiply_name);
    if (libmultiply == null) {
        std.debug.print("Failed to load {s}\n", .{libmultiply_name});
        return;
    }

    const multiply = c.load_multiply_function(libmultiply);
    const multiply_result = multiply.?(2, 3);
    std.debug.print("Multiply: {}\n", .{multiply_result});
    c.close_library(libmultiply);
}
