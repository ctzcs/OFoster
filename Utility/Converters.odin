package foster_utility

import "core:fmt"
import "core:strings"

Vector2Converter :: struct {}
Vector3Converter :: struct {}
Vector4Converter :: struct {}
Matrix3x2Converter :: struct {}
FloatVectorJsonConverter :: struct {}
IntVectorJsonConverter :: struct {}
FloatVectorToString :: proc(values: []f32) -> string { b:=strings.builder_make(); defer strings.builder_destroy(&b); strings.write_string(&b,"["); for i,v in values { if i>0 {strings.write_string(&b,", ")}; strings.write_string(&b,fmt.aprintf("%g",v)) }; strings.write_string(&b,"]"); return strings.to_string(b) }
IntVectorToString :: proc(values: []int) -> string { b:=strings.builder_make(); defer strings.builder_destroy(&b); strings.write_string(&b,"["); for i,v in values { if i>0 {strings.write_string(&b,", ")}; strings.write_string(&b,fmt.aprintf("%d",v)) }; strings.write_string(&b,"]"); return strings.to_string(b) }
