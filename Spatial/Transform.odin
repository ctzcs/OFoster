package foster_spatial

import "core:math"

Matrix3x2 :: struct {
	M11, M12: f32,
	M21, M22: f32,
	M31, M32: f32,
}

Matrix3x2Identity :: Matrix3x2{1, 0, 0, 1, 0, 0}

Matrix3x2TransformPoint :: proc(m: Matrix3x2, point: Vec2) -> Vec2 {
	return Vec2{point[0]*m.M11 + point[1]*m.M21 + m.M31, point[0]*m.M12 + point[1]*m.M22 + m.M32}
}

Matrix3x2Inverse :: proc(m: Matrix3x2) -> (Matrix3x2, bool) {
	determinant := m.M11*m.M22 - m.M12*m.M21
	if math.abs(determinant) <= 1e-8 do return Matrix3x2Identity, false
	inv := 1/determinant
	result := Matrix3x2{
		M11 = m.M22*inv, M12 = -m.M12*inv,
		M21 = -m.M21*inv, M22 = m.M11*inv,
	}
	result.M31 = -(m.M31*result.M11 + m.M32*result.M21)
	result.M32 = -(m.M31*result.M12 + m.M32*result.M22)
	return result, true
}

Transform :: struct {
	Position: Vec2,
	Scale: Vec2,
	Rotation: f32,
	TransformIndex: int,
	matrix_dirty: bool,
	inverse_dirty: bool,
	cached_matrix: Matrix3x2,
	cached_inverse: Matrix3x2,
}

TransformIdentity :: Transform{Scale = Vec2{1, 1}, cached_matrix = Matrix3x2Identity, cached_inverse = Matrix3x2Identity}

TransformMake :: proc(position: Vec2 = {}, scale: Vec2 = {1, 1}, rotation: f32 = 0) -> Transform {
	return Transform{Position = position, Scale = scale, Rotation = rotation, matrix_dirty = true, inverse_dirty = true}
}

TransformCreateMatrix :: proc(position, origin, scale: Vec2, rotation: f32) -> Matrix3x2 {
	cosine := math.cos(rotation)
	sine := math.sin(rotation)
	m := Matrix3x2{
		M11 = cosine*scale[0], M12 = sine*scale[0],
		M21 = -sine*scale[1], M22 = cosine*scale[1],
	}
	m.M31 = position[0] - origin[0]*m.M11 - origin[1]*m.M21
	m.M32 = position[1] - origin[0]*m.M12 - origin[1]*m.M22
	return m
}

transform_dirty :: proc(transform: ^Transform) { transform.TransformIndex += 1; transform.matrix_dirty = true; transform.inverse_dirty = true }
TransformSetPosition :: proc(transform: ^Transform, position: Vec2) { if transform.Position != position { transform.Position = position; transform_dirty(transform) } }
TransformSetScale :: proc(transform: ^Transform, scale: Vec2) { if transform.Scale != scale { transform.Scale = scale; transform_dirty(transform) } }
TransformSetRotation :: proc(transform: ^Transform, rotation: f32) { if transform.Rotation != rotation { transform.Rotation = rotation; transform_dirty(transform) } }

TransformMatrix :: proc(transform: ^Transform) -> Matrix3x2 {
	if transform.matrix_dirty { transform.cached_matrix = TransformCreateMatrix(transform.Position, Vec2{}, transform.Scale, transform.Rotation); transform.matrix_dirty = false }
	return transform.cached_matrix
}

TransformMatrixInverse :: proc(transform: ^Transform) -> Matrix3x2 {
	if transform.inverse_dirty { transform.cached_inverse, _ = Matrix3x2Inverse(TransformMatrix(transform)); transform.inverse_dirty = false }
	return transform.cached_inverse
}

TransformPoint :: proc(transform: ^Transform, point: Vec2) -> Vec2 { return Matrix3x2TransformPoint(TransformMatrix(transform), point) }
TransformPointInverse :: proc(transform: ^Transform, point: Vec2) -> Vec2 { return Matrix3x2TransformPoint(TransformMatrixInverse(transform), point) }
