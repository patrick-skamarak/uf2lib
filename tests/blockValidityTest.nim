discard """
    exitcode: 0
"""

import ../src/uf2lib

doAssert( (sizeof Block) == 512, "Expected block size of 512." )

var blk : Block

doAssert( not validMagic blk, "Expected invalid block.")

blk = initBlock()

doAssert( blk.magicStart0 == 0x0A324655'u32, "Expected correct magicStart0 value." )
doAssert( blk.magicStart1 == 0x9E5D5157'u32, "Expected correct magicStart1 value." )
doAssert( blk.magicEnd == 0x0AB16F30'u32, "Expected correct magicEnd value." )

doAssert( validMagic blk, "Expected valid block." )