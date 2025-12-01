const std = @import("std");

/// this library never is never actually built itself
pub fn build(_: *std.Build) void {}

pub fn loadDotEnv(run: *std.Build.Step.Run) void {
    const log = std.log.scoped(.btzdotenv);
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    var env_file = std.fs.cwd().openFile(".env", .{}) catch |e| {
        switch (e) {
            error.FileNotFound => {
                log.info(
                    \\ No .env file found
                , .{});
            },
            else => {
                log.err(
                    \\ build.zig could not open .env file: {any}
                , .{e});
            },
        }
        return;
    };

    defer env_file.close();

    const read_buffer = arena.alloc(u8, 2048) catch @panic("out of memory");
    var reader = env_file.reader(read_buffer);

    const contents = reader.interface.allocRemaining(arena, .unlimited) catch @panic("failed to read");

    var lines = std.mem.splitScalar(u8, contents, '\n');
    while (lines.next()) |line| {
        const trimmed = std.mem.trim(u8, line, " \t\r");
        if (trimmed.len == 0 or trimmed[0] == '#') continue;

        var parts = std.mem.splitScalar(u8, trimmed, '=');

        const key = parts.first();
        const value = std.mem.trim(u8, parts.rest(), " \"");

        run.setEnvironmentVariable(key, value);
    }
}
