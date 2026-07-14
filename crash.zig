// compile with zig build-exe crash.zig -lntdll
const std = @import("std");

extern fn RtlAdjustPrivilege(
    privilege: u32,
    enable: bool,
    currThread: bool,
    statusPointer: *bool
) callconv(.c) u32;

extern fn NtRaiseHardError(
    errorStatus: u32,
    useless1: u32,
    useless2: u32,
    useless3: ?*usize,
    responseOption: u32,
    responsePointer: *u32
) callconv(.c) u32;

pub fn main() void {
    var privilegeState = false;
    var errorResponse: u32 = 0

    _ = RtlAdjustPrivilege(19, true, false, &privilegeState);
    std.debug.print("Crashing...\n", .{});
    _ = NtRaiseHardError(
        0xC0000006,
        0,
        0,
        null,
        6,
        &errorResponse
    );
    std.debug.print("Crash failed!\n", .{});
}
