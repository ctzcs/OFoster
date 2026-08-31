package foster_input_bindings

import enums "../Enums"

KeyboardKeyBinding :: struct { Key: enums.Keys }
KeyboardKeyBindingMake :: proc(key: enums.Keys) -> KeyboardKeyBinding { return KeyboardKeyBinding{key} }
KeyboardKeyBindingDescriptor :: proc(binding: KeyboardKeyBinding) -> string { return "Keyboard Key" }
