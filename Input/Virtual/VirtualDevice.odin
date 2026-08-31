package foster_input_virtual

import runtime "../.."
import sets "../Sets"

VirtualDeviceIndexMode :: enum { Manual, AutomaticLatest }
VirtualDevice :: struct {
	Base: VirtualInput,
	IndexMode: VirtualDeviceIndexMode,
	Inputs: [dynamic]^VirtualInput,
	actions: [dynamic]^VirtualAction,
	axes: [dynamic]^VirtualAxis,
	sticks: [dynamic]^VirtualStick,
}
VirtualDeviceMake :: proc(input: ^runtime.Input, name: string, controller_index := 0) -> VirtualDevice { return VirtualDevice{Base=VirtualInputMake(input,name,controller_index),IndexMode=.Manual} }
VirtualDeviceSetControllerIndex :: proc(v: ^VirtualDevice, index: int) { if v.IndexMode == .Manual { v.Base.ControllerIndex=index; for p in v.Inputs { p.ControllerIndex=index } } }
VirtualDeviceAddAction :: proc(v: ^VirtualDevice, name: string, set := sets.ActionBindingSet{}, buffer := f32(0)) -> ^VirtualAction { a := new(VirtualAction); a^=VirtualActionMake(v.Base.Input,name,set,v.Base.ControllerIndex,buffer); append(&v.actions,a); append(&v.Inputs,&a.Base); return a }
VirtualDeviceAddAxis :: proc(v: ^VirtualDevice, name: string, set := sets.AxisBindingSet{}) -> ^VirtualAxis { a := new(VirtualAxis); a^=VirtualAxisMake(v.Base.Input,name,set,v.Base.ControllerIndex); append(&v.axes,a); append(&v.Inputs,&a.Base); return a }
VirtualDeviceAddStick :: proc(v: ^VirtualDevice, name: string, set := sets.StickBindingSet{}) -> ^VirtualStick { s := new(VirtualStick); s^=VirtualStickMake(v.Base.Input,name,set,v.Base.ControllerIndex); append(&v.sticks,s); append(&v.Inputs,&s.Base); return s }
VirtualDeviceUpdate :: proc(v: ^VirtualDevice, t: runtime.Time) {
	if v.IndexMode == .AutomaticLatest && v.Base.Input != nil { latest:=0; for i in 1..<runtime.InputMaxControllers { if v.Base.Input.State.Controllers[i].IsGamepad && v.Base.Input.State.Controllers[i].InputTimestamp > v.Base.Input.State.Controllers[latest].InputTimestamp { latest=i } }; v.Base.ControllerIndex=latest; for p in v.Inputs { p.ControllerIndex=latest } }
	for a in v.actions { VirtualActionUpdate(a,t) }; for a in v.axes { VirtualAxisUpdate(a,t) }; for s in v.sticks { VirtualStickUpdate(s,t) }
}
VirtualDeviceDispose :: proc(v: ^VirtualDevice) { if v.Base.IsDisposed { return }; for p in v.Inputs { VirtualInputDispose(p) }; clear(&v.Inputs); clear(&v.actions); clear(&v.axes); clear(&v.sticks); v.Base.IsDisposed=true }
VirtualDeviceIsGamepadLatest :: proc(v: ^VirtualDevice) -> bool { if v.Base.Input == nil || v.Base.ControllerIndex < 0 || v.Base.ControllerIndex >= runtime.InputMaxControllers { return false }; c:=&v.Base.Input.State.Controllers[v.Base.ControllerIndex]; return c.IsGamepad && c.InputTimestamp > v.Base.Input.State.Keyboard.InputTimestamp }
