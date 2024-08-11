# Package

version       = "0.1.0"
author        = "Pradeep Gowda"
description   = "A simple Statically Linked Web APp"
license       = "MIT"
srcDir        = "."
bin           = @["app"]


# Dependencies

requires "nim >= 2.0.8"
requires "prologue >= 0.6.6"
requires "db_connector >= 0.1.0"

requires "markdown >= 0.8.8"