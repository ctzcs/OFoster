package foster_utility

StackList4 :: struct($T: typeid) { Data: [4]T, Count: int }
StackList8 :: struct($T: typeid) { Data: [8]T, Count: int }
StackList16 :: struct($T: typeid) { Data: [16]T, Count: int }
StackList32 :: struct($T: typeid) { Data: [32]T, Count: int }
StackList64 :: struct($T: typeid) { Data: [64]T, Count: int }

stack_add :: proc(list: ^$L, value: $T) where intrinsics.type_is_struct(L) {
	if list.Count >= len(list.Data) { panic("Exceeding Capacity of StackList") }; list.Data[list.Count]=value; list.Count+=1
}
StackList4Add :: proc(list: ^StackList4($T), value:T){stack_add(list,value)}
StackList8Add :: proc(list: ^StackList8($T), value:T){stack_add(list,value)}
StackList16Add :: proc(list: ^StackList16($T), value:T){stack_add(list,value)}
StackList32Add :: proc(list: ^StackList32($T), value:T){stack_add(list,value)}
StackList64Add :: proc(list: ^StackList64($T), value:T){stack_add(list,value)}
StackList4Clear :: proc(list: ^StackList4($T)){list.Count=0}
StackList8Clear :: proc(list: ^StackList8($T)){list.Count=0}
StackList16Clear :: proc(list: ^StackList16($T)){list.Count=0}
StackList32Clear :: proc(list: ^StackList32($T)){list.Count=0}
StackList64Clear :: proc(list: ^StackList64($T)){list.Count=0}
