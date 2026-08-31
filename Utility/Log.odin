package foster_utility

import "core:fmt"

LogState :: struct { History: [dynamic]string, OnInfo: proc(msg: string), OnWarning: proc(msg: string), OnError: proc(msg: string) }
log_append :: proc(state: ^LogState, message: string) { append(&state.History,message) }
LogInfo :: proc(state: ^LogState, message: string) { log_append(state,message); if state.OnInfo != nil { state.OnInfo(message) } else { fmt.println(message) } }
LogWarning :: proc(state: ^LogState, message: string) { log_append(state,message); if state.OnWarning != nil { state.OnWarning(message) } else { fmt.println(message) } }
LogError :: proc(state: ^LogState, message: string) { log_append(state,message); if state.OnError != nil { state.OnError(message) } else { fmt.println(message) } }
LogClearHistory :: proc(state: ^LogState) { clear(&state.History) }
LogHistory :: proc(state: ^LogState) -> []string { return state.History[:] }
