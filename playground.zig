const std = @import("std");
const testing = std.testing;
const expect = testing.expect;

test "assignment" {
    const constant = 5;
    try expect(constant == 5);
    var variable: u8 = 5;
    try expect(variable == 5);
    variable = 6;
    try expect(variable == 6);
    const bigger_variable = @as(u32, variable);
    try expect(bigger_variable == 6);
    const undefined_constant: u8 = undefined;
    try expect(undefined_constant == 6); // TODO check if this is expected
}
