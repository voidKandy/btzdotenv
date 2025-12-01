# Build-Time Dot Env Sourcing
This is a very simple repo that allows you to source a .env file at build time in your zig project.

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


