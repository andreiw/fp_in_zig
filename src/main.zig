const std = @import("std");
const dot = ".".*;
const dotdot = "..".*;

const c = @cImport({
   @cInclude("unistd.h");
});

fn process(path: []const u8, opt_host: ?[]const u8) void {
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

   if (opt_host) |host| {
      std.debug.print("{s}@{s}:", .{c.getlogin(), host});
   }

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
    var host_buf: [std.c.HOST_NAME_MAX]u8 = undefined;
    var host: ?[]const u8 = null;

    var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = general_purpose_allocator.allocator();
    const args = try std.process.argsAlloc(gpa);
    defer std.process.argsFree(gpa, args);

    if (std.mem.eql(u8, std.fs.path.basename(args[0]), "sfp")) {
       host = std.os.gethostname(&host_buf) catch "localhost";
    }

    if (args.len == 1) {
       process(&dot, host);
    } else {
        for (args) |arg, i| {
            if (i == 0) {
               continue;
            }
            process(arg, host);
        }
    }
}
