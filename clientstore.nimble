srcDir        = "src"
binDir        = "bin"
bin           = @["clientstore"]

# Package

version       = "0.1.0"
author        = "Nael Tasmim"
description   = "sqlite wrapper"
license       = "BSD"

# Dependencies

requires "nim >= 0.17.2", "encryption", "protocol"
