package foster_input_virtual

import runtime "../.."
import sets "../Sets"

VirtualAxis :: struct { Base: VirtualInput, Set: sets.AxisBindingSet, Value: f32, IntValue: int, PressedSign: int }
VirtualAxisMake :: proc(input: ^runtime.Input, name: string, set := sets.AxisBindingSet{}, controller_index := 0) -> VirtualAxis { return VirtualAxis{Base=VirtualInputMake(input,name,controller_index),Set=set} }
VirtualAxisUpdate :: proc(v: ^VirtualAxis, t: runtime.Time) { _ = t; if v.Base.IsDisposed || !v.Base.Active || v.Base.Input == nil { return }; v.Value=sets.AxisBindingSetValue(&v.Set,v.Base.Input,v.Base.ControllerIndex); if v.Value > 0 { v.IntValue=1 } else if v.Value < 0 { v.IntValue=-1 } else { v.IntValue=0 }; v.PressedSign=sets.AxisBindingSetPressedSign(&v.Set,v.Base.Input,v.Base.ControllerIndex) }
VirtualAxisManualUpdate :: proc(v: ^VirtualAxis, t: runtime.Time) { VirtualAxisUpdate(v, t) }
VirtualAxisPressed :: proc(v: ^VirtualAxis) -> bool { return v.PressedSign != 0 }
VirtualAxisPressedNegative :: proc(v: ^VirtualAxis) -> bool { return v.PressedSign < 0 }
VirtualAxisPressedPositive :: proc(v: ^VirtualAxis) -> bool { return v.PressedSign > 0 }
VirtualAxisClear :: proc(v: ^VirtualAxis) { v.Value=0; v.IntValue=0; v.PressedSign=0 }
VirtualAxisSetControllerIndex :: proc(v: ^VirtualAxis,index:int) { VirtualInputSetControllerIndex(&v.Base,index) }
