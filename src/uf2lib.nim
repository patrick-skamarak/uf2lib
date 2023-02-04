import uf2lib/[uf2block, uf2flags, uf2families], streams

type Uf2IOError* = ref Exception

const FILE_EXISTS = "The specified file already exists."
const INVALID_BLOCK = "An invalid block was found; The specified file is corrupted or not a valid UF2 file."

proc raiseUf2IOError( reason : string ) = 
    var err = Uf2IOError()
    err.msg = reason
    raise err

type Uf2File = ref object
    fileName : string
    fs : FileStream

proc openFileStream*( uf2File : Uf2File, fileMode : FileMode) : FileStream =
    if isNil uf2File.fs:
        result = openFileStream(uf2File.fileName, fileMode)
        uf2File.fs = result

proc closeFileStream*( uf2File : Uf2File ) =
    if not isNil uf2File.fs :
        uf2File.fs.close()
        uf2File.fs = nil

proc newUf2File*( fileName : string ) : Uf2File =
    result = Uf2File()
    result.fileName = fileName
    try:
        discard result.openFileStream(fmRead)
        result.closeFileStream()
        raiseUf2IOError(FILE_EXISTS)
    except IOError:
        discard
    except Uf2IOError:
        raise
    discard result.openFileStream(fmWrite)
    result.closeFileStream()

proc openUf2File*( fileName : string ) : Uf2File =
    result = Uf2File()
    result.fileName = fileName
    var fs = result.openFileStream(fmRead)
    while not atEnd fs:
        var blk : Block
        discard fs.readData(addr blk, sizeof Block)
        if not validMagic blk:
            raiseUf2IOError(INVALID_BLOCK)
    result.closeFileStream()
 
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