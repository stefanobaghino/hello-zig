const std = @import("std");
const testing = std.testing;
const expect = testing.expect;

test "basic test" {
    try expect(47 == 42 + 5);
}

test "while loop" {
    try expect(42 == 42);
}
