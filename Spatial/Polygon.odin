package foster_spatial

import "core:math"

Polygon :: struct {
	Vertices: [dynamic]Vec2,
	Indices:  [dynamic]u32,
}

PolygonMake :: proc(vertices: ..Vec2) -> Polygon {
	result: Polygon
	for vertex in vertices { append(&result.Vertices, vertex) }
	PolygonTriangulate(&result)
	return result
}

PolygonAdd :: proc(polygon: ^Polygon, vertex: Vec2) { append(&polygon.Vertices, vertex); PolygonTriangulate(polygon) }
PolygonClear :: proc(polygon: ^Polygon) { clear(&polygon.Vertices); clear(&polygon.Indices) }
PolygonCount :: proc(polygon: Polygon) -> int { return len(polygon.Vertices) }
PolygonArea :: proc(polygon: ^Polygon) -> f32 {
	area: f32 = 0
	if len(polygon.Vertices) < 3 do return 0
	for i := 1; i < len(polygon.Vertices)-1; i += 1 { area += TriangleArea(Triangle{polygon.Vertices[0],polygon.Vertices[i],polygon.Vertices[i+1]}) }
	return area
}

PolygonTriangulate :: proc(polygon: ^Polygon) {
	clear(&polygon.Indices)
	if len(polygon.Vertices) < 3 do return
	for i := 1; i < len(polygon.Vertices)-1; i += 1 { append(&polygon.Indices, 0, u32(i), u32(i+1)) }
}

PolygonBounds :: proc(polygon: Polygon) -> Rect {
	if len(polygon.Vertices) == 0 do return Rect{}
	min := polygon.Vertices[0]; max := min
	for point in polygon.Vertices[1:] { min[0]=math.min(min[0],point[0]); min[1]=math.min(min[1],point[1]); max[0]=math.max(max[0],point[0]); max[1]=math.max(max[1],point[1]) }
	return RectBetween(min,max)
}

PolygonContains :: proc(polygon: Polygon, point: Vec2) -> bool {
	inside := false
	count := len(polygon.Vertices)
	if count < 3 do return false
	for i := 0; i < count; i += 1 { a:=polygon.Vertices[i]; b:=polygon.Vertices[(i+1)%count]; if ((a[1] > point[1]) != (b[1] > point[1])) && point[0] < (b[0]-a[0])*(point[1]-a[1])/(b[1]-a[1])+a[0] { inside = !inside } }
	return inside
}

PolygonMove :: proc(polygon: ^Polygon, offset: Vec2) { for i := 0; i < len(polygon.Vertices); i += 1 { polygon.Vertices[i] = vec2_add(polygon.Vertices[i],offset) } }
