import uf2lib/[uf2block, uf2flags, uf2families], streams

type 
    Uf2File* = ref object
        fileName : string
        numBlocks : uint32
        fileSize : int64
        fs : FileStream
    Uf2IOError* = ref object of IOError

proc raiseUf2IOError( msg : string ) = 
    var err = Uf2IOError()
    err.msg = msg
    raise err

proc numBlocks*( uf2File : Uf2File ) : uint32 = 
    result = uf2File.numBlocks

proc newUf2File*( fileName : string ) : Uf2File = 
    result = Uf2File()
    result.fileName = fileName
    result.numBlocks = 0


proc open*( uf2File : Uf2File, fileMode : FileMode ) : FileStream =
    uf2File.fs = newFileStream(uf2File.fileName, fileMode)
    result = uf2File.fs

proc close*( uf2File : Uf2File ) = 
    close(uf2File.fs)

proc getUf2File*( fileName : string ) : Uf2File =
    result = newUf2File(fileName)
    var fs = result.open(fmRead)
    var blk : Block
    discard fs.readData(addr blk, sizeof Block)
    if not validMagic blk:
        raiseUf2IOError("Invalid Uf2 file.")
    result.numBlocks = blk.numBlocks
    result.close()

proc readBlock*( uf2File : Uf2File, blockNum : uint32 ) : Block =
    if blockNum >= uf2File.numBlocks or blockNum < 0:
        raiseUf2IOError("Index out of bounds.")
    var fs = uf2File.open(fmRead)
    fs.setPosition((int blockNum) * (int sizeof Block))
    discard fs.readData(addr result, sizeof Block)
    fs.close()
    uf2File.close()

proc writeBlock*( uf2File : Uf2File, blk : var Block ) =
    var fs = uf2File.open(fmWrite)
    fs.writeData(addr blk, sizeof Block)
    uf2File.fileSize = uf2File.fileSize+sizeof Block
    uf2File.numBlocks = uf2File.numBlocks+1
    uf2File.close()
 
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