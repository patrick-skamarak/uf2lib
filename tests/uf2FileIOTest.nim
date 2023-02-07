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
var uf2FileInfo = newUf2File(HAPPY_FILE)

doAssert(fileExists(HAPPY_FILE), "Expected file to exist.")

var fileStream = uf2FileInfo.openFileStream(fmWrite)
fileStream.writeData(addr blk, sizeof Block)
fileStream.close()

# can read file written
var blk2 : Block
var uf2FileInfo2 = openUf2File(HAPPY_FILE)

var fileStream2 = uf2FileInfo2.openFileStream(fmRead)
discard fileStream2.readData(addr blk2, sizeof Block)
fileStream2.close()

doAssert(validMagic blk2, "Expected valid magic.")

removeFile(HAPPY_FILE)
removeFile(SAD_FILE)