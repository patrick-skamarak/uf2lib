import uf2lib/[uf2block, uf2flags, uf2families], json

type 
    Uf2File* = ref object
        fileName : string
        numBlocks : uint32
        fileSize : int64
        file : File
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
    result.file = open(fileName)
    if not getFileSize(result.file) >= sizeof Block :
        raiseUf2IOError("Invalid Uf2 file.")
    result.fileSize = result.file.getFileSize()
    var blk : Block
    discard result.file.readBuffer(addr blk, sizeof Block)
    if not validMagic blk:
        raiseUf2IOError("Invalid Uf2 file.")
    result.numBlocks = blk.numBlocks
    close(result.file)

proc open*( uf2File : Uf2File ) : File =
    uf2File.file = open(uf2File.fileName)
    result = uf2File.file;

proc close*( uf2File : Uf2File ) = 
    close(uf2File.file)

proc readBlock*( uf2File : Uf2File, blockNum : uint32 ) : Block =
    if blockNum >= uf2File.numBlocks or blockNum < 0:
        raiseUf2IOError("Index out of bounds.")
    var file = uf2File.open()
    file.setFilePos((int64 blockNum) * (int64 sizeof Block))
    discard file.readBuffer(addr result, sizeof Block)
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