package foster_internal

Utf8FromString :: proc(value:string)->string{return value}
import "core:strings"

Utf8Allocate :: proc(value:string)->cstring { result, _ := strings.clone_to_cstring(value, context.allocator); return result }
Utf8Free :: proc(value:cstring){ _ = delete_cstring(value, context.allocator) }
