# config.nims
import std/strutils

# Determine the architecture
const arch = staticExec("uname -m").strip()

# Set the appropriate library path based on architecture
const libPath =
  case arch
  of "x86_64": "/usr/lib/x86_64-linux-gnu/libm.a"
  of "aarch64": "/usr/lib/aarch64-linux-gnu/libm.a"
  of "armv7l": "/usr/lib/arm-linux-gnueabihf/libm.a"
  else: "/usr/lib/libm.a"  # fallback path

when defined(linux):
  switch("cc", "gcc")
  switch("define", "release")
  switch("define", "nimDebugDlOpen")
  # Ensure we're using static versions of libraries
  switch("passL", "-static-libgcc")
  # Static PIE configuration for Linux
  switch("passC", "-fPIC -static-pie -O3")
  switch("passL", "-fPIC -static-pie -O3")
  # Static libraries (Alpine specific paths)
  switch("passL", "/usr/local/lib/libpcre.a")
  switch("passL", "/usr/local/lib/libsqlite3.a")
  # Use the determined library path
  switch("passL", libPath)
  # Dynamic library overrides
  switch("dynlibOverride", "pcre")
  switch("dynlibOverride", "sqlite3")
  # Additional linker flags
  switch("passL", "-static -lm")
else:
  # Configuration for non-Linux systems
  switch("passC", "-O3")
  switch("passL", "-O3")

# Optimize for size (commented out as per your original file)
# switch("opt", "size")

# You can uncomment the following line if you want to apply these settings only to app.nim
# --hint[Conf]: off
# when commandLineParams.len > 0 and commandLineParams[^1] == "app.nim":
