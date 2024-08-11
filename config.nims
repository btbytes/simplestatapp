# config.nims

# Release mode
switch("define", "release")

# Optimize for size
# switch("opt", "size")

# Debug DL open
switch("define", "nimDebugDlOpen")

# Compiler and linker flags
switch("passC", "-fPIC -pie -O3")
switch("passL", "-fPIC -pie -O3")

# Static libraries
switch("passL", "/usr/lib/x86_64-linux-gnu/libpcre32.a")
switch("passL", "/usr/lib/x86_64-linux-gnu/libsqlite3.a")

# Dynamic library overrides
switch("dynlibOverride", "pcre")
switch("dynlibOverride", "sqlite3")

# Additional linker flags
switch("passL", "-static -lm -lpcre -lsqlite3")

# You can uncomment the following line if you want to apply these settings only to app.nim
# --hint[Conf]: off
# when commandLineParams.len > 0 and commandLineParams[^1] == "app.nim":
