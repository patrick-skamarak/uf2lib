discard """
    exitcode: 0
"""
import ../src/uf2lib, streams, os

# test set-up start
const HAPPY_FILE = "./tests/happyFile.uf2"
const SAD_FILE = "./tests/sadFile.uf2"

var fs = openFileStream(SAD_FILE, fmWrite)
fs.write("HI")
fs.close()
# test set-up end

# file doesn't exist
var caughtError = false
try:
    discard openUf2File(HAPPY_FILE)
except Uf2IOError:
    caughtError = true

doAssert(caughtError, "Expected an error.")

# file has bad block
caughtError = false
try:
    discard openUf2File(SAD_FILE)
except Uf2IOError:
    caughtError = true

doAssert(caughtError, "Expected an error.")

# creates a new file
var blk = initBlock()
var uf2File = newUf2File(HAPPY_FILE)
doAssert(fileExists(HAPPY_FILE), "Expected file to exist.")
uf2File.openFileStream(fmWrite).writeData(addr blk, sizeof Block)
uf2File.closeFileStream()

# can read file written
var blk2 : Block
var uf2File2 = openUf2File(HAPPY_FILE)
discard uf2File2.openFileStream(fmRead).readData(addr blk2, sizeof Block)
uf2File.closeFileStream()
doAssert(validMagic blk2, "Expected valid magic.")

removeFile(HAPPY_FILE)
removeFile(SAD_FILE)