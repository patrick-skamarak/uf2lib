import json, strutils

const
    # magic numbers
    MAGIC_START_0* = 0x0A324655'u32
    MAGIC_START_1* = 0x9E5D5157'u32
    MAGIC_END* = 0x0AB16F30'u32

type
    Block* = object
        magicStart0*: uint32 # First magic number, 0x0A324655 ("UF2\n")
        magicStart1*: uint32 # Second magic number, 0x9E5D5157
        flags*: uint32 # flags
        targetAddr*: uint32 # Address in flash where the data should be written
        payloadSize*: uint32 # Number of bytes used in data (often 256)
        blockNo*: uint32 # Sequential block number; starts at 0
        numBlocks*: uint32 # Total number of blocks in file
        fileSize*: uint32 # File size or board family ID or zero
        data*: array[476, uint8] # Data, padded with zeros
        magicEnd*: uint32 # Final magic number, 0x0AB16F30

proc initBlock* () : Block =
    result = Block()
    result.magicStart0 = MAGIC_START_0
    result.magicStart1 = MAGIC_START_1
    result.magicEnd = MAGIC_END

proc validMagic* (`block` : Block) : bool = 
    if `block`.magicStart0 != MAGIC_START_0 : return false
    if `block`.magicStart1 != MAGIC_START_1 : return false
    if `block`.magicEnd != MAGIC_END : return false
    return true

proc `%`*(`block` : Block) : JsonNode =
    result = %{
        "magicStart0" : %("0x"&`block`.magicStart0.toHex()),
        "magicStart1" : %("0x"&`block`.magicStart1.toHex()),
        "flags" : %("0x"&`block`.flags.toHex()),
        "targetAddr" : %("0x"&`block`.targetAddr.toHex()),
        "payloadSize" : %`block`.payloadSize,
        "blockNo" : %`block`.blockNo,
        "numBlocks" : %`block`.numBlocks,
        "fileSize" : %("0x"&`block`.fileSize.toHex()),
        "data" : %`block`.data,
        "magicEnd" : %("0x"&`block`.magicEnd.toHex())
    }