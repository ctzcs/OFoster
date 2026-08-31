package foster_input

import runtime ".."
import enums "./Enums"
import coretime "core:time"

InputProvider :: struct { Input: ^runtime.Input }
InputProviderMake :: proc() -> InputProvider { p:=InputProvider{}; p.Input=new(runtime.Input); runtime.InputInit(p.Input,nil); return p }
InputProviderUpdate :: proc(p:^InputProvider,t:runtime.Time){if p.Input!=nil{runtime.InputStep(p.Input,t)}}
InputProviderText :: proc(p:^InputProvider,text:string){if p.Input!=nil {p.Input.State.Keyboard.Text=text}}
InputProviderKey :: proc(p:^InputProvider,key:enums.Keys,pressed:bool,stamp:coretime.Duration){if p.Input!=nil{runtime.InputKey(p.Input,key,pressed,stamp)}}
InputProviderMouseButton :: proc(p:^InputProvider,button:enums.MouseButtons,pressed:bool,stamp:coretime.Duration){if p.Input!=nil{runtime.InputMouseButton(p.Input,button,pressed,stamp)}}
InputProviderMouseMove :: proc(p:^InputProvider,position,delta:runtime.Vec2f,stamp:coretime.Duration){if p.Input!=nil{runtime.InputMouseMove(p.Input,position,delta,stamp)}}
InputProviderMouseWheel :: proc(p:^InputProvider,wheel:runtime.Vec2f){if p.Input!=nil{runtime.InputMouseWheel(p.Input,wheel)}}
InputProviderControllerButton :: proc(p:^InputProvider,id:runtime.ControllerID,button:int,pressed:bool,stamp:coretime.Duration){if p.Input!=nil{runtime.InputControllerButton(p.Input,id,button,pressed,stamp)}}
InputProviderControllerAxis :: proc(p:^InputProvider,id:runtime.ControllerID,axis:int,value:f32,stamp:coretime.Duration){if p.Input!=nil{runtime.InputControllerAxis(p.Input,id,axis,value,stamp)}}
