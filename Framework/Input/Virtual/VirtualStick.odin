package foster_input_virtual

import runtime "../.."
import sets "../Sets"
import bindings "../Bindings"

VirtualStick :: struct { Base: VirtualInput, Set: sets.StickBindingSet, Value: [2]f32, IntValue: runtime.Point2, PressedLeft, PressedRight, PressedUp, PressedDown: bool }
VirtualStickMake :: proc(input: ^runtime.Input, name: string, set := sets.StickBindingSet{}, controller_index := 0) -> VirtualStick { return VirtualStick{Base=VirtualInputMake(input,name,controller_index),Set=set} }
VirtualStickUpdate :: proc(v: ^VirtualStick, t: runtime.Time) { _ = t; if v.Base.IsDisposed || v.Base.Input == nil { return }; v.Value=sets.StickBindingSetValue(&v.Set,v.Base.Input,v.Base.ControllerIndex); v.IntValue=runtime.Point2{}; if v.Value[0] < 0 { v.IntValue.X=-1 }; if v.Value[0] > 0 { v.IntValue.X=1 }; if v.Value[1] < 0 { v.IntValue.Y=-1 }; if v.Value[1] > 0 { v.IntValue.Y=1 }; v.PressedLeft=false; v.PressedRight=false; v.PressedUp=false; v.PressedDown=false; for e in v.Set.Entries { l:=bindings.BindingGetState(e.Left,v.Base.Input,v.Base.ControllerIndex); r:=bindings.BindingGetState(e.Right,v.Base.Input,v.Base.ControllerIndex); u:=bindings.BindingGetState(e.Up,v.Base.Input,v.Base.ControllerIndex); d:=bindings.BindingGetState(e.Down,v.Base.Input,v.Base.ControllerIndex); v.PressedLeft |= l.Pressed; v.PressedRight |= r.Pressed; v.PressedUp |= u.Pressed; v.PressedDown |= d.Pressed } }
VirtualStickClear :: proc(v: ^VirtualStick) { v.Value={}; v.IntValue={}; v.PressedLeft=false; v.PressedRight=false; v.PressedUp=false; v.PressedDown=false }
VirtualStickSetControllerIndex :: proc(v: ^VirtualStick,index:int) { VirtualInputSetControllerIndex(&v.Base,index) }
