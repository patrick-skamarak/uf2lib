discard """
    exitcode: 0
"""
import ../src/uf2lib

var uf2File : Uf2File

uf2File = newUf2File("./tests/blink.uf2")

doAssert(uf2File.numBlocks == 50, "Expected 50 blocks")

var err : Uf2IOError
try:
    discard uf2File.readBlock(50)
except Uf2IOError:
    err = UF2IOError getCurrentException()
doAssert(err.msg == "Index out of bounds.")

# hopefully these test cases are not too contrived

try:
    discard newUf2File("./tests/somefile")
except Uf2IOError:
    err = UF2IOError getCurrentException()
doAssert(err.msg == "Invalid Uf2 file.")
