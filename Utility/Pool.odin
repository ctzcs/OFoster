package foster_utility

Pool :: struct($T: typeid) { Available: [dynamic]T }
PoolGet :: proc(pool: ^Pool($T)) -> T { if len(pool.Available)>0 { n:=len(pool.Available)-1; v:=pool.Available[n]; resize(&pool.Available,n); return v }; return T{} }
PoolReturn :: proc(pool: ^Pool($T), value:T){append(&pool.Available,value)}
PoolClear :: proc(pool: ^Pool($T)){clear(&pool.Available)}
IPoolable :: #type proc(value: rawptr)
