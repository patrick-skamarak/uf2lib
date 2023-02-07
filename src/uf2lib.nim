import uf2lib/[uf2block, uf2flags, uf2families], streams

type Uf2IOError* = ref Exception

const FILE_EXISTS = "The specified file already exists."
const INVALID_BLOCK = "An invalid block was found; The specified file is corrupted or not a valid UF2 file."

proc raiseUf2IOError( reason : string ) = 
    var err = Uf2IOError()
    err.msg = reason
    raise err

type
    Uf2FileInfo* = object
        blockOffsets : seq[uint32]
        fileName : string

proc blockOffsets*( uf2FileInfo : Uf2FileInfo ) : seq[uint32] = 
    result = uf2FileInfo.blockOffsets

proc openFileStream*( uf2FileInfo : Uf2FileInfo, fileMode : FileMode ) : FileStream = 
    result = openFileStream(uf2FileInfo.fileName, fileMode)

proc newUf2File*( fileName : string ) : Uf2FileInfo =
    result = Uf2FileInfo()
    result.fileName = fileName
    result.blockOffsets = newSeq[uint32]()
    try:
        var fs = result.openFileStream(fmRead)
        fs.close()
        raiseUf2IOError(FILE_EXISTS)
    except IOError:
        discard
    except Uf2IOError:
        raise
    var fs = result.openFileStream(fmWrite)
    fs.close()

proc openUf2File*( fileName : string ) : Uf2FileInfo =
    result = Uf2FileInfo()
    result.fileName = fileName
    var fs = result.openFileStream(fmRead)
    while not atEnd fs:
        var blk : Block
        result.blockOffsets.add(uint32 fs.getPosition())
        discard fs.readData(addr blk, sizeof Block)
        if not validMagic blk:
            raiseUf2IOError(INVALID_BLOCK)
        
    fs.close()
 
export 
    # uf2block
    uf2block.Block, 
    uf2block.initBlock,
    uf2block.validMagic, 
    uf2block.MAGIC_START_0,
    uf2block.MAGIC_START_1,
    uf2block.MAGIC_END,
    uf2block.`%`,

    # uf2flags
    uf2flags.Flag, 
    uf2flags.toggleFlag, 
    uf2flags.hasFlag,

    # uf2families
    uf2families.setFamily, 
    uf2families.familiesTable,
    uf2families.UnknownFamilyException