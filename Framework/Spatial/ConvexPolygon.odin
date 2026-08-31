package foster_spatial

import "core:math"

ConvexPolygon :: struct { Vertices: [dynamic]Vec2 }
ConvexPolygonMake :: proc(vertices: ..Vec2) -> ConvexPolygon { result: ConvexPolygon; for vertex in vertices { append(&result.Vertices,vertex) }; return result }
ConvexPolygonAdd :: proc(polygon: ^ConvexPolygon, vertex: Vec2) { append(&polygon.Vertices,vertex) }
ConvexPolygonCount :: proc(polygon: ConvexPolygon) -> int { return len(polygon.Vertices) }
ConvexPolygonBounds :: proc(polygon: ConvexPolygon) -> Rect {
	if len(polygon.Vertices)==0 do return Rect{}
	min:=polygon.Vertices[0];max:=min
	for p in polygon.Vertices[1:] { min[0]=math.min(min[0],p[0]);min[1]=math.min(min[1],p[1]);max[0]=math.max(max[0],p[0]);max[1]=math.max(max[1],p[1]) }
	return RectBetween(min,max)
}
ConvexPolygonCenter :: proc(polygon: ConvexPolygon) -> Vec2 { return RectCenter(ConvexPolygonBounds(polygon)) }
ConvexPolygonAverage :: proc(polygon: ConvexPolygon) -> Vec2 { result:Vec2;for p in polygon.Vertices { result=vec2_add(result,p) };if len(polygon.Vertices)>0 do result=vec2_scale(result,1/f32(len(polygon.Vertices)));return result }
ConvexPolygonContains :: proc(polygon: ConvexPolygon, point: Vec2) -> bool {
	if len(polygon.Vertices)<3 do return false
	sign := 0
	for i:=0;i<len(polygon.Vertices);i+=1 { cross:=triangle_cross(vec2_sub(polygon.Vertices[(i+1)%len(polygon.Vertices)],polygon.Vertices[i]),vec2_sub(point,polygon.Vertices[i])); if cross != 0 { current:=1;if cross<0 do current=-1;if sign==0 {sign=current} else if sign!=current do return false } }
	return true
}
ConvexPolygonProject :: proc(polygon: ConvexPolygon, axis: Vec2) -> (min,max:f32) { if len(polygon.Vertices)==0 do return 0,0;min=vec2_dot(polygon.Vertices[0],axis);max=min;for p in polygon.Vertices[1:] {d:=vec2_dot(p,axis);min=math.min(min,d);max=math.max(max,d)};return }
ConvexPolygonEdges :: proc(polygon: ConvexPolygon) -> [dynamic]Line { edges:[dynamic]Line;for i:=0;i<len(polygon.Vertices);i+=1 { append(&edges,Line{polygon.Vertices[i],polygon.Vertices[(i+1)%len(polygon.Vertices)]}) };return edges }
