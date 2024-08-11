# config.nims

when defined(linux):
  switch("define", "release")
  switch("define", "nimDebugDlOpen")
  # Dynamic library overrides
  switch("dynlibOverride", "pcre")
  switch("dynlibOverride", "sqlite3")
  # Additional linker flags
  switch("passL", "-static -lsqlite3 -lpcre -lm")
else:
  # Configuration for non-Linux systems
  switch("passC", "-O3")
  switch("passL", "-O3")

# Optimize for size (commented out as per your original file)
# switch("opt", "size")

# You can uncomment the following line if you want to apply these settings only to app.nim
# --hint[Conf]: off
# when commandLineParams.len > 0 and commandLineParams[^1] == "app.nim":
