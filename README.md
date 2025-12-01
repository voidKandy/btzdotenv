# Build-Time Dot Env Sourcing
A minimal Zig library for sourcing a `.env` file at build time.

### Usage
1. Add as a dependency to your zig project
```bash
zig fetch --save "git+https://github.com/voidKandy/btzdotenv"
```
2. Use in your `build.zig` file
```zig
// First you need add a run artifact to some executable
const run_cmd = b.addRunArtifact(exe);
@import("btzdotenv").loadDotEnv(run_cmd);
```
3. Access your variable through `std.process`
```zig
var env_map = try std.process.getEnvMap(self.allocator);
defer env_map.deinit();
const client_id = env_map.get("CLIENT_ID").?;
const client_secret = env_map.get("CLIENT_SECRET").?;
```


### Why?
Many dotenv libraries require you to load and manage environment variables through a separate object, which can lead to redundant calls or confusion about variable sources.

This tiny library simplifies the process: it parses a .env file and injects the key/value pairs directly into the environment of a single process.
