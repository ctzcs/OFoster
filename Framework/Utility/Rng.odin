package foster_utility

import "core:math"
import spatial "../Spatial"

Rng :: struct { Seed: u64 }
RngMake :: proc(seed: u64) -> Rng { return Rng{Seed=seed} }
RngU64 :: proc(r: ^Rng) -> u64 { r.Seed += 0x9e3779b97f4a7c15; n:=r.Seed; n=(n ~ (n>>30))*0xbf58476d1ce4e5b9; n=(n ~ (n>>27))*0x94d049bb133111eb; return n ~ (n>>31) }
RngU64Max :: proc(r: ^Rng, max:u64) -> u64 { if max==0{return 0}; return RngU64(r)%max }
RngU64Range :: proc(r: ^Rng,min,max:u64)->u64{return min+RngU64Max(r,max-min)}
RngU32 :: proc(r: ^Rng)->u32{return u32(RngU64(r))}
RngU32Max :: proc(r:^Rng,max:u32)->u32{if max==0{return 0};return RngU32(r)%max}
RngU32Range :: proc(r:^Rng,min,max:u32)->u32{return min+RngU32Max(r,max-min)}
RngInt :: proc(r:^Rng)->int{return int(RngU64(r))}
RngIntMax :: proc(r:^Rng,max:int)->int{if max<=0{return 0};return int(RngU64Max(r,u64(max)))}
RngIntRange :: proc(r:^Rng,min,max:int)->int{return min+RngIntMax(r,max-min)}
RngFloat :: proc(r:^Rng)->f32{return f32(RngU32(r)>>8)/f32(1<<24)}
RngFloatMax :: proc(r:^Rng,max:f32)->f32{return RngFloat(r)*max}
RngFloatRange :: proc(r:^Rng,min,max:f32)->f32{return min+RngFloatMax(r,max-min)}
RngDouble :: proc(r:^Rng)->f64{return f64(RngU64(r)>>11)/f64(1<<53)}
RngBoolean :: proc(r:^Rng)->bool{return (RngU64(r)&1)!=0}
RngChance :: proc(r:^Rng,p:f32)->bool{return RngFloat(r)<p}
RngAngle :: proc(r:^Rng)->f32{return RngFloatMax(r,f32(math.TAU))}
RngChoose :: proc(r:^Rng, choices: []$T)->T{if len(choices)==0{return {}};return choices[RngIntMax(r,len(choices))]}
RngShuffle :: proc(r:^Rng, values: []$T){for i:=len(values)-1;i>0;i-=1{j:=RngIntMax(r,i+1);values[i],values[j]=values[j],values[i]}}
RngPointInside :: proc(r:^Rng, rect: spatial.Rect)->spatial.Vec2{return spatial.RectOn(rect,RngFloat(r),RngFloat(r))}
