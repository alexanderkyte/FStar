
open Prims
# 4 "FStar.Const.fst"
type sconst =
| Const_effect
| Const_unit
| Const_uint8 of Prims.byte
| Const_bool of Prims.bool
| Const_int32 of Prims.int32
| Const_int64 of Prims.int64
| Const_int of Prims.string
| Const_char of Prims.char
| Const_float of Prims.double
| Const_bytearray of (Prims.byte Prims.array * FStar_Range.range)
| Const_string of (Prims.byte Prims.array * FStar_Range.range)
| Const_range of FStar_Range.range

# 5 "FStar.Const.fst"
let is_Const_effect = (fun _discr_ -> (match (_discr_) with
| Const_effect (_) -> begin
true
end
| _ -> begin
false
end))

# 6 "FStar.Const.fst"
let is_Const_unit = (fun _discr_ -> (match (_discr_) with
| Const_unit (_) -> begin
true
end
| _ -> begin
false
end))

# 7 "FStar.Const.fst"
let is_Const_uint8 = (fun _discr_ -> (match (_discr_) with
| Const_uint8 (_) -> begin
true
end
| _ -> begin
false
end))

# 8 "FStar.Const.fst"
let is_Const_bool = (fun _discr_ -> (match (_discr_) with
| Const_bool (_) -> begin
true
end
| _ -> begin
false
end))

# 9 "FStar.Const.fst"
let is_Const_int32 = (fun _discr_ -> (match (_discr_) with
| Const_int32 (_) -> begin
true
end
| _ -> begin
false
end))

# 10 "FStar.Const.fst"
let is_Const_int64 = (fun _discr_ -> (match (_discr_) with
| Const_int64 (_) -> begin
true
end
| _ -> begin
false
end))

# 11 "FStar.Const.fst"
let is_Const_int = (fun _discr_ -> (match (_discr_) with
| Const_int (_) -> begin
true
end
| _ -> begin
false
end))

# 12 "FStar.Const.fst"
let is_Const_char = (fun _discr_ -> (match (_discr_) with
| Const_char (_) -> begin
true
end
| _ -> begin
false
end))

# 13 "FStar.Const.fst"
let is_Const_float = (fun _discr_ -> (match (_discr_) with
| Const_float (_) -> begin
true
end
| _ -> begin
false
end))

# 14 "FStar.Const.fst"
let is_Const_bytearray = (fun _discr_ -> (match (_discr_) with
| Const_bytearray (_) -> begin
true
end
| _ -> begin
false
end))

# 15 "FStar.Const.fst"
let is_Const_string = (fun _discr_ -> (match (_discr_) with
| Const_string (_) -> begin
true
end
| _ -> begin
false
end))

# 16 "FStar.Const.fst"
let is_Const_range = (fun _discr_ -> (match (_discr_) with
| Const_range (_) -> begin
true
end
| _ -> begin
false
end))

# 7 "FStar.Const.fst"
let ___Const_uint8____0 = (fun projectee -> (match (projectee) with
| Const_uint8 (_16_3) -> begin
_16_3
end))

# 8 "FStar.Const.fst"
let ___Const_bool____0 = (fun projectee -> (match (projectee) with
| Const_bool (_16_6) -> begin
_16_6
end))

# 9 "FStar.Const.fst"
let ___Const_int32____0 = (fun projectee -> (match (projectee) with
| Const_int32 (_16_9) -> begin
_16_9
end))

# 10 "FStar.Const.fst"
let ___Const_int64____0 = (fun projectee -> (match (projectee) with
| Const_int64 (_16_12) -> begin
_16_12
end))

# 11 "FStar.Const.fst"
let ___Const_int____0 = (fun projectee -> (match (projectee) with
| Const_int (_16_15) -> begin
_16_15
end))

# 12 "FStar.Const.fst"
let ___Const_char____0 = (fun projectee -> (match (projectee) with
| Const_char (_16_18) -> begin
_16_18
end))

# 13 "FStar.Const.fst"
let ___Const_float____0 = (fun projectee -> (match (projectee) with
| Const_float (_16_21) -> begin
_16_21
end))

# 14 "FStar.Const.fst"
let ___Const_bytearray____0 = (fun projectee -> (match (projectee) with
| Const_bytearray (_16_24) -> begin
_16_24
end))

# 15 "FStar.Const.fst"
let ___Const_string____0 = (fun projectee -> (match (projectee) with
| Const_string (_16_27) -> begin
_16_27
end))

# 16 "FStar.Const.fst"
let ___Const_range____0 = (fun projectee -> (match (projectee) with
| Const_range (_16_30) -> begin
_16_30
end))




