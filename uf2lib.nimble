# Package

version       = "1.1.0"
author        = "Patrick Skamarak"
description   = "A uf2 library for nim."
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.0.0"

# Tasks
task test, "Runs tests":
    exec """testament pattern "./tests/*Test.nim""""