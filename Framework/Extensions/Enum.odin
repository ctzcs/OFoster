package foster_extensions

EnumHas :: proc(flags, check: $T) -> bool { return (flags & check) != 0 }
EnumHasAll :: proc(flags, check: $T) -> bool { return (flags & check) == check }
EnumWith :: proc(flags, value: $T) -> T { return flags | value }
EnumWithout :: proc(flags, value: $T) -> T { return flags & ~value }
EnumMask :: proc(flags, value: $T, condition: bool) -> T { if condition { return EnumWith(flags,value) }; return EnumWithout(flags,value) }
