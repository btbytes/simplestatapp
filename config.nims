# config.nims

# Use GCC as the C compiler
switch("cc", "gcc")
switch("gcc.exe", "gcc")
switch("gcc.linkerexe", "gcc")

# Release mode
switch("define", "release")

# Debug DL open
switch("define", "nimDebugDlOpen")

# OS-specific configuration
when defined(linux):
  # Static PIE configuration for Linux
  switch("passC", "-fPIC -static-pie -O3")
  switch("passL", "-fPIC -static-pie -O3")

  # Static libraries
  switch("passL", "/usr/lib/x86_64-linux-gnu/libpcre32.a")
  switch("passL", "/usr/lib/x86_64-linux-gnu/libsqlite3.a")

  # Dynamic library overrides
  switch("dynlibOverride", "pcre")
  switch("dynlibOverride", "sqlite3")

  # Additional linker flags
  switch("passL", "-static -lm -lpcre -lsqlite3")
else:
  # Configuration for non-Linux systems
  switch("passC", "-O3")
  switch("passL", "-O3")

# Optimize for size (commented out as per your original file)
# switch("opt", "size")

# You can uncomment the following line if you want to apply these settings only to app.nim
# --hint[Conf]: off
# when commandLineParams.len > 0 and commandLineParams[^1] == "app.nim":
