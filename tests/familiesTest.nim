discard """
    exitcode: 0
"""

import ../src/uf2lib

# Bad Family Short Name
var didRaiseException = false
try:
    var blk = initBlock()
    blk.setFamily("BADVAL")
except UnknownFamilyException:
    didRaiseException = true
finally:
    doAssert(didRaiseException == true, "Expected exception.")

# Good Family Short Name
didRaiseException = false
try:
    var blk = initBlock()
    blk.setFamily("RP2040")
    doAssert(blk.fileSize == 0xe48bff56'u32, "Expected correct value.")
except Exception:
    didRaiseException = true
finally:
    doAssert(didRaiseException == false, "Expected no exception.")

# Set Hex Directly
didRaiseException = false
try:
    var blk = initBlock()
    blk.setFamily(0x00000001'u32)
    doAssert(blk.fileSize == 0x00000001'u32, "Expected correct value.")
except Exception:
    didRaiseException = true
finally:
    doAssert(didRaiseException == false, "Expected no exception.")
