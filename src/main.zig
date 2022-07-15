const std = @import("std");
const dot = ".".*;
const dotdot = "..".*;

fn process(path: []const u8) anyerror!void {
   var buf: [std.fs.MAX_PATH_BYTES]u8 = undefined;

   var d = std.fs.path.dirname(path);
   var real_d = d orelse blk: {
      if (std.fs.path.isAbsolute(path)) {
         break :blk "/";
      }

      break :blk ".";
   };

   var r = std.fs.realpath(real_d, &buf) catch |err| {
      std.debug.print("{s} doesn't exist: {s}\n", .{real_d, err});
      return;
   };

   var b = std.fs.path.basename(path);
   if (std.mem.eql(u8, b, &dot) or std.mem.eql(u8, b, &dotdot)) {
      std.debug.print("{s}\n", .{r});
      return;
   }

   if (std.mem.eql(u8, real_d, "/")) {
      std.debug.print("/{s}\n", .{b});   
   } else {
      std.debug.print("{s}/{s}\n", .{r, b});
   }
}

pub fn main() anyerror!void {
    var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = general_purpose_allocator.allocator();
    const args = try std.process.argsAlloc(gpa);
    defer std.process.argsFree(gpa, args);

    if (args.len == 1) {
       try process(&dot);
    } else {
        for (args) |arg, i| {
            if (i == 0) {
               continue;
            }
            try process(arg);
        }
    }
}
