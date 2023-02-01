discard """
    exitcode: 0
    joinable: true
"""

import ../src/uf2lib

var blk = Block()

# assert no flags
doAssert( not blk.hasFlag(NOT_MAIN_FLASH), "Unexpected flag." )
doAssert( not blk.hasFlag(FILE_CONTAINER), "Unexpected flag." )
doAssert( not blk.hasFlag(FAMILY_ID_PRESENT), "Unexpected flag." )
doAssert( not blk.hasFlag(MD5_CHECKSUM_PRESENT), "Unexpected flag." )
doAssert( not blk.hasFlag(EXTENSION_TAGS_PRESENT), "Unexpected flag." )

# toggle flags on
blk.toggleFlag(NOT_MAIN_FLASH)
blk.toggleFlag(FILE_CONTAINER)
blk.toggleFlag(FAMILY_ID_PRESENT)
blk.toggleFlag(MD5_CHECKSUM_PRESENT)
blk.toggleFlag(EXTENSION_TAGS_PRESENT)

# assert has flags
doAssert( blk.hasFlag(NOT_MAIN_FLASH), "Expected flag." )
doAssert( blk.hasFlag(FILE_CONTAINER), "Expected flag." )
doAssert( blk.hasFlag(FAMILY_ID_PRESENT), "Expected flag." )
doAssert( blk.hasFlag(MD5_CHECKSUM_PRESENT), "Expected flag." )
doAssert( blk.hasFlag(EXTENSION_TAGS_PRESENT), "Expected flag." )

blk.toggleFlag(NOT_MAIN_FLASH);

# assert toggled off

doAssert( not blk.hasFlag(NOT_MAIN_FLASH), "Unexpected flag." )