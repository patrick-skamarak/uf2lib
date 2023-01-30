import json, tables, strutils, uf2block, uf2flags

const familiesJson = staticRead("./uf2families.json");
var familiesTable* : Table[string, string]

for item in parseJson(familiesJson).items:
    familiesTable[item.getOrDefault("short_name").getStr()] = item.getOrDefault("id").getStr()

type UnknownFamilyException = ref Exception

proc raiseUnknownFamilyException(family : string) = 
    var exception = UnknownFamilyException()
    exception.msg = "Family short name \""&family&"\" was not found."
    raise exception

proc setFamily* ( `block` : BlockRef , id : uint32 ) : void = 
    `block`.fileSize = id
    if not `block`.hasFlag FAMILY_ID_PRESENT :
        `block`.toggleFlag FAMILY_ID_PRESENT

proc setFamily* (`block` : BlockRef, shortName : string ) : void =
    if familiesTable.hasKey(shortName):
        `block`.setFamily(cast[uint32](strutils.parseHexInt(familiesTable[shortName])))
    else:
        raiseUnknownFamilyException(shortName)

when isMainModule:
    # Bad Family Short Name
    var didRaiseException = false
    try:
        var blk = newBlockRef()
        blk.setFamily("BADVAL")
    except UnknownFamilyException:
        didRaiseException = true
    finally:
        doAssert(didRaiseException == true, "Expected exception.")

    # Good Family Short Name
    didRaiseException = false
    try:
        var blk = newBlockRef()
        blk.setFamily("RP2040")
        doAssert(blk.fileSize == 0xe48bff56'u32, "Expected correct value.")
    except Exception:
        didRaiseException = true
    finally:
        doAssert(didRaiseException == false, "Expected no exception.")

    # Set Hex Directly
    didRaiseException = false
    try:
        var blk = newBlockRef()
        blk.setFamily(0x00000001'u32)
        doAssert(blk.fileSize == 0x00000001'u32, "Expected correct value.")
    except Exception:
        didRaiseException = true
    finally:
        doAssert(didRaiseException == false, "Expected no exception.")
