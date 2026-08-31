package foster_utility

import spatial "../Spatial"

TriangulationEnumerable :: struct { Vertices: []spatial.Vec2, Triangles: []int }
TriangulationEnumerableMake :: proc(vertices: []spatial.Vec2, triangles: []int) -> TriangulationEnumerable { return TriangulationEnumerable{vertices,triangles} }
TriangulationEnumerator :: struct { Vertices: []spatial.Vec2, Triangles: []int, Index: int, Current: spatial.Triangle }
TriangulationEnumeratorGet :: proc(value: TriangulationEnumerable) -> TriangulationEnumerator { return TriangulationEnumerator{Vertices=value.Vertices,Triangles=value.Triangles,Index=-3} }
TriangulationMoveNext :: proc(e: ^TriangulationEnumerator) -> bool { e.Index += 3; if e.Index+2 >= len(e.Triangles) { return false }; e.Current=spatial.Triangle{e.Vertices[e.Triangles[e.Index]],e.Vertices[e.Triangles[e.Index+1]],e.Vertices[e.Triangles[e.Index+2]]}; return true }
