package foster_extensions

NumberHas :: proc(flags,check:$T)->bool{return (flags & check)!=0}
NumberHasAll :: proc(flags,check:$T)->bool{return (flags & check)==check}
NumberWith :: proc(flags,value:$T)->T{return flags|value}
NumberWithout :: proc(flags,value:$T)->T{return flags & ~value}
NumberMask :: proc(flags,value:$T,condition:bool)->T{if condition{return flags|value};return flags & ~value}
