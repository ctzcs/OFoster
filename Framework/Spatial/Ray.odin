package foster_spatial

Ray :: struct {
	Position: Vec2,
	Direction: Vec2,
}

RayMake :: proc(position, direction: Vec2) -> Ray { return Ray{position, direction} }
RayAt :: proc(ray: Ray, distance: f32) -> Vec2 { return vec2_add(ray.Position, vec2_scale(ray.Direction, distance)) }
