package foster_input_virtual

import runtime "../.."

VirtualInput :: struct {
	Input: ^runtime.Input,
	Name: string,
	ControllerIndex: int,
	Active: bool,
	IsDisposed: bool,
}

VirtualInputMake :: proc(input: ^runtime.Input, name: string, controller_index := 0) -> VirtualInput {
	return VirtualInput{Input=input, Name=name, ControllerIndex=controller_index, Active=true}
}
VirtualInputDispose :: proc(v: ^VirtualInput) { v.IsDisposed = true }
VirtualInputSetControllerIndex :: proc(v: ^VirtualInput, index: int) { if index >= 0 { v.ControllerIndex = index } }
VirtualInputSetActive :: proc(v: ^VirtualInput, active: bool) { if v != nil { v.Active = active } }
VirtualInputIsActive :: proc(v: ^VirtualInput) -> bool { return v != nil && v.Active && !v.IsDisposed }
