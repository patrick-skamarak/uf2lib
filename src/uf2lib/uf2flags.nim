import bitops, uf2block

type
    Flag* = enum
        NOT_MAIN_FLASH = 0x00000001'u32
        FILE_CONTAINER = 0x00001000'u32
        FAMILY_ID_PRESENT = 0x00002000'u32
        MD5_CHECKSUM_PRESENT = 0x00004000'u32
        EXTENSION_TAGS_PRESENT = 0x00008000'u32

proc toggleFlag* (`block`: var Block, flag : Flag ) =
    `block`.flags = bitxor(`block`.flags, uint32 flag)

proc hasFlag* (`block` : Block, flag : Flag): bool = 
    if bitand(`block`.flags, uint32 flag) == uint32 flag :
        result = true
    else:
        result = false