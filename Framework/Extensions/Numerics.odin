package foster_extensions

import "core:math"
import spatial "../Spatial"

// Quaternion mirrors System.Numerics.Quaternion for callers that need the
// small set of orientation helpers exposed by Foster's numerics extensions.
Quaternion :: struct { X, Y, Z, W: f32 }
QuaternionConjugated :: proc(q: Quaternion) -> Quaternion { return Quaternion{-q.X, -q.Y, -q.Z, q.W} }

quaternion_from_basis :: proc(right, up, forward: spatial.Vec3) -> Quaternion {
	// Convert an orthonormal 3x3 basis to a quaternion (trace-stable form).
	trace := right[0] + up[1] + forward[2]
	if trace > 0 {
		s := math.sqrt(trace + 1) * 2
		return Quaternion{(up[2]-forward[1])/s, (forward[0]-right[2])/s, (right[1]-up[0])/s, 0.25*s}
	}
	if right[0] > up[1] && right[0] > forward[2] {
		s := math.sqrt(1+right[0]-up[1]-forward[2])*2
		return Quaternion{0.25*s, (right[1]+up[0])/s, (forward[0]+right[2])/s, (up[2]-forward[1])/s}
	}
	if up[1] > forward[2] {
		s := math.sqrt(1+up[1]-right[0]-forward[2])*2
		return Quaternion{(right[1]+up[0])/s, 0.25*s, (up[2]+forward[1])/s, (forward[0]-right[2])/s}
	}
	s := math.sqrt(1+forward[2]-right[0]-up[1])*2
	return Quaternion{(forward[0]+right[2])/s, (up[2]+forward[1])/s, 0.25*s, (right[1]-up[0])/s}
}

QuaternionLookAtDirection :: proc(direction, up: spatial.Vec3) -> Quaternion {
	forward := Vec3Normalized(direction, spatial.Vec3{0, 0, -1})
	right := Vec3Normalized(Vec3Cross(up, forward), spatial.Vec3{1, 0, 0})
	true_up := Vec3Cross(forward, right)
	return quaternion_from_basis(right, true_up, forward)
}

QuaternionLookAt :: proc(from, to, up: spatial.Vec3) -> Quaternion { return QuaternionLookAtDirection(spatial.Vec3{to[0]-from[0], to[1]-from[1], to[2]-from[2]}, up) }

Vec3Cross :: proc(a, b: spatial.Vec3) -> spatial.Vec3 { return spatial.Vec3{a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2], a[0]*b[1]-a[1]*b[0]} }

Vec2Clamp :: proc(v, min, max: spatial.Vec2) -> spatial.Vec2 { return spatial.Vec2{math.clamp(v[0],min[0],max[0]),math.clamp(v[1],min[1],max[1])} }
Vec2Normalized :: proc(v: spatial.Vec2, fallback: spatial.Vec2 = {}) -> spatial.Vec2 { l2:=v[0]*v[0]+v[1]*v[1]; if l2==0{return fallback}; inv:=1/math.sqrt(l2); return spatial.Vec2{v[0]*inv,v[1]*inv} }
Vec2ClampRect :: proc(v: spatial.Vec2, bounds: spatial.Rect) -> spatial.Vec2 { return Vec2Clamp(v, spatial.RectMin(bounds), spatial.RectMax(bounds)) }
Vec2Floor :: proc(v: spatial.Vec2) -> spatial.Vec2 { return spatial.Vec2{math.floor(v[0]),math.floor(v[1])} }
Vec2Round :: proc(v: spatial.Vec2) -> spatial.Vec2 { return spatial.Vec2{math.round(v[0]),math.round(v[1])} }
Vec2Ceiling :: proc(v: spatial.Vec2) -> spatial.Vec2 { return spatial.Vec2{math.ceil(v[0]),math.ceil(v[1])} }
Vec2RoundToPoint2 :: proc(v: spatial.Vec2) -> spatial.Point2 { return spatial.Point2{int(math.round(v[0])),int(math.round(v[1]))} }
Vec2FloorToPoint2 :: proc(v: spatial.Vec2) -> spatial.Point2 { return spatial.Point2{int(math.floor(v[0])),int(math.floor(v[1]))} }
Vec2CeilingToPoint2 :: proc(v: spatial.Vec2) -> spatial.Point2 { return spatial.Point2{int(math.ceil(v[0])),int(math.ceil(v[1]))} }
Vec2TurnRight :: proc(v:spatial.Vec2)->spatial.Vec2{return spatial.Vec2{-v[1],v[0]}}
Vec2TurnLeft :: proc(v:spatial.Vec2)->spatial.Vec2{return spatial.Vec2{v[1],-v[0]}}
Vec2Angle :: proc(v:spatial.Vec2)->f32{return math.atan2(v[1],v[0])}
Vec2LengthSquared :: proc(v: spatial.Vec2) -> f32 { return v[0]*v[0]+v[1]*v[1] }
Vec2LengthLessThan :: proc(v: spatial.Vec2, length: f32) -> bool { return Vec2LengthSquared(v) < length*length }
Vec2GetLengthAndNormalize :: proc(v: spatial.Vec2, fallback: spatial.Vec2 = {}) -> (spatial.Vec2, f32) { l2:=Vec2LengthSquared(v); if l2==0{return fallback,0}; l:=math.sqrt(l2); return spatial.Vec2{v[0]/l,v[1]/l},l }
Vec2FourWayNormal :: proc(v: spatial.Vec2, fallback: spatial.Vec2 = {}) -> spatial.Vec2 { if v=={} {return fallback}; a:=math.round(Vec2Angle(v)/(math.PI*0.5))*(math.PI*0.5);r:=spatial.Vec2{math.cos(a),math.sin(a)};if math.abs(r[0])<.1{r[0]=0;r[1]=math.sign(r[1])};if math.abs(r[1])<.1{r[1]=0;r[0]=math.sign(r[0])};return r }
Vec2EightWayNormal :: proc(v: spatial.Vec2, fallback: spatial.Vec2 = {}) -> spatial.Vec2 { if v=={} {return fallback}; a:=math.round(Vec2Angle(v)/(math.PI*0.25))*(math.PI*0.25);r:=spatial.Vec2{math.cos(a),math.sin(a)};if math.abs(r[0])<.1{r[0]=0;r[1]=math.sign(r[1])};if math.abs(r[1])<.1{r[1]=0;r[0]=math.sign(r[0])};return r }
Vec2Abs :: proc(v:spatial.Vec2)->spatial.Vec2{return spatial.Vec2{math.abs(v[0]),math.abs(v[1])}}
Vec2ZeroX :: proc(v:spatial.Vec2)->spatial.Vec2{return spatial.Vec2{0,v[1]}}
Vec2ZeroY :: proc(v:spatial.Vec2)->spatial.Vec2{return spatial.Vec2{v[0],0}}
Vec2IsSmallerThan :: proc(a,b: spatial.Vec2) -> bool { return Vec2LengthSquared(a) < Vec2LengthSquared(b) }
Vec2Map :: proc(v: spatial.Vec2, from_bounds, to_bounds: spatial.Rect) -> spatial.Vec2 { return spatial.Vec2{((v[0]-from_bounds.X)/from_bounds.Width)*to_bounds.Width+to_bounds.X,((v[1]-from_bounds.Y)/from_bounds.Height)*to_bounds.Height+to_bounds.Y} }

Vec3Normalized :: proc(v: spatial.Vec3, fallback: spatial.Vec3 = {}) -> spatial.Vec3 { l2:=v[0]*v[0]+v[1]*v[1]+v[2]*v[2];if l2==0{return fallback};l:=math.sqrt(l2);return spatial.Vec3{v[0]/l,v[1]/l,v[2]/l} }
Vec3XY :: proc(v: spatial.Vec3) -> spatial.Vec2 { return spatial.Vec2{v[0],v[1]} }
Vec3WithXY :: proc(v: spatial.Vec3, xy: spatial.Vec2) -> spatial.Vec3 { return spatial.Vec3{xy[0],xy[1],v[2]} }
Vec3Round :: proc(v: spatial.Vec3) -> spatial.Vec3 { return spatial.Vec3{math.round(v[0]),math.round(v[1]),math.round(v[2])} }
Vec3Floor :: proc(v: spatial.Vec3) -> spatial.Vec3 { return spatial.Vec3{math.floor(v[0]),math.floor(v[1]),math.floor(v[2])} }
Vec3Ceiling :: proc(v: spatial.Vec3) -> spatial.Vec3 { return spatial.Vec3{math.ceil(v[0]),math.ceil(v[1]),math.ceil(v[2])} }
Vec3RoundToPoint3 :: proc(v: spatial.Vec3) -> spatial.Point3 { return spatial.Point3{int(math.round(v[0])),int(math.round(v[1])),int(math.round(v[2]))} }
Vec3FloorToPoint3 :: proc(v: spatial.Vec3) -> spatial.Point3 { return spatial.Point3{int(math.floor(v[0])),int(math.floor(v[1])),int(math.floor(v[2]))} }
Vec3CeilingToPoint3 :: proc(v: spatial.Vec3) -> spatial.Point3 { return spatial.Point3{int(math.ceil(v[0])),int(math.ceil(v[1])),int(math.ceil(v[2]))} }

Vec4 :: [4]f32
Vec4Round :: proc(v: Vec4) -> Vec4 { return Vec4{math.round(v[0]),math.round(v[1]),math.round(v[2]),math.round(v[3])} }
Vec4Floor :: proc(v: Vec4) -> Vec4 { return Vec4{math.floor(v[0]),math.floor(v[1]),math.floor(v[2]),math.floor(v[3])} }
Vec4Ceiling :: proc(v: Vec4) -> Vec4 { return Vec4{math.ceil(v[0]),math.ceil(v[1]),math.ceil(v[2]),math.ceil(v[3])} }

Matrix3x2XScaleFast :: proc(m: spatial.Matrix3x2) -> f32 { return m.M11 }
Matrix3x2YScaleFast :: proc(m: spatial.Matrix3x2) -> f32 { return m.M22 }
Matrix3x2ScaleFast :: proc(m: spatial.Matrix3x2) -> spatial.Vec2 { return spatial.Vec2{m.M11,m.M22} }
Matrix3x2XScale :: proc(m: spatial.Matrix3x2) -> f32 { return math.sqrt(m.M11*m.M11+m.M21*m.M21) }
Matrix3x2YScale :: proc(m: spatial.Matrix3x2) -> f32 { return math.sqrt(m.M12*m.M12+m.M22*m.M22) }
Matrix3x2Scale :: proc(m: spatial.Matrix3x2) -> spatial.Vec2 { return spatial.Vec2{Matrix3x2XScale(m),Matrix3x2YScale(m)} }
