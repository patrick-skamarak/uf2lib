import json, tables, strutils, uf2block, uf2flags

const familiesJson = staticRead("./uf2families.json");
var familiesTable* : Table[string, string]

for item in parseJson(familiesJson).items:
    familiesTable[item.getOrDefault("short_name").getStr()] = item.getOrDefault("id").getStr()

type UnknownFamilyException* = ref Exception

proc raiseUnknownFamilyException(family : string) = 
    var exception = UnknownFamilyException()
    exception.msg = "Family short name \""&family&"\" was not found."
    raise exception

proc setFamily* ( `block` : var Block , id : uint32 ) : void = 
    `block`.fileSize = id
    if not `block`.hasFlag FAMILY_ID_PRESENT :
        `block`.toggleFlag FAMILY_ID_PRESENT

proc setFamily* (`block` : var Block, shortName : string ) : void =
    if familiesTable.hasKey(shortName):
        `block`.setFamily(cast[uint32](strutils.parseHexInt(familiesTable[shortName])))
    else:
        raiseUnknownFamilyException(shortName)