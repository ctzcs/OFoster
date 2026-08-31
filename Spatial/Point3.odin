package foster_spatial

import "core:math"

Vec3 :: [3]f32
Point3 :: struct { X, Y, Z: int }
Point3Make1 :: proc(value: int) -> Point3 { return Point3{value,value,value} }
Point3Make2 :: proc(x, y: int) -> Point3 { return Point3{x,y,0} }
Point3Make3 :: proc(x, y, z: int) -> Point3 { return Point3{x,y,z} }
Point3Make :: proc{Point3Make1, Point3Make2, Point3Make3}
Point3Zero :: Point3{}
Point3One :: Point3{1, 1, 1}
Point3Left :: Point3{-1, 0, 0}
Point3Right :: Point3{1, 0, 0}
Point3Up :: Point3{0, -1, 0}
Point3Down :: Point3{0, 1, 0}
Point3Forward :: Point3{0, 0, 1}
Point3Backward :: Point3{0, 0, -1}
Point3Length :: proc(p: Point3) -> f32 { return math.sqrt(f32(p.X*p.X + p.Y*p.Y + p.Z*p.Z)) }
Point3LengthSquared :: proc(p: Point3) -> f32 { return f32(p.X*p.X + p.Y*p.Y + p.Z*p.Z) }
Point3Vector3 :: proc(p: Point3) -> Vec3 { return Vec3{f32(p.X), f32(p.Y), f32(p.Z)} }
Point3Normalized :: proc(p: Point3) -> Vec3 {
	v := Point3Vector3(p); l := math.sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]); if l == 0 do return Vec3{}; return Vec3{v[0]/l, v[1]/l, v[2]/l}
}
Point3GetLengthAndNormalize :: proc(p: Point3, fallback: Vec3 = {}) -> (result: Vec3, length: f32) {
	result = Point3Vector3(p); length = math.sqrt(result[0]*result[0] + result[1]*result[1] + result[2]*result[2]); if length == 0 { result = fallback; return }; result = Vec3{result[0]/length, result[1]/length, result[2]/length}; return
}
Point3Add :: proc(a, b: Point3) -> Point3 { return Point3{a.X+b.X, a.Y+b.Y, a.Z+b.Z} }
Point3Sub :: proc(a, b: Point3) -> Point3 { return Point3{a.X-b.X, a.Y-b.Y, a.Z-b.Z} }
Point3Scale :: proc(p: Point3, scalar: int) -> Point3 { return Point3{p.X*scalar, p.Y*scalar, p.Z*scalar} }
Point3ScaleFloat :: proc(p: Point3, scalar: f32) -> Vec3 { return Vec3{f32(p.X)*scalar, f32(p.Y)*scalar, f32(p.Z)*scalar} }
Point3Negate :: proc(p:Point3)->Point3{return Point3{-p.X,-p.Y,-p.Z}}
Point3Div :: proc(p:Point3,scalar:int)->Point3{if scalar==0{return {}};return Point3{p.X/scalar,p.Y/scalar,p.Z/scalar}}
Point3Mod :: proc(p:Point3,scalar:int)->Point3{if scalar==0{return {}};return Point3{p.X%scalar,p.Y%scalar,p.Z%scalar}}
Point3DivFloat :: proc(p:Point3,scalar:f32)->Vec3{if scalar==0{return {}};return Vec3{f32(p.X)/scalar,f32(p.Y)/scalar,f32(p.Z)/scalar}}
Point3ModFloat :: proc(p:Point3,scalar:f32)->Vec3{if scalar==0{return {}};return Vec3{math.mod(f32(p.X),scalar),math.mod(f32(p.Y),scalar),math.mod(f32(p.Z),scalar)}}
