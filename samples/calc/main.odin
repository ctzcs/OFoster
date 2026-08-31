package main

import "core:fmt"
import utility "../../Framework/Utility"
import spatial "../../Framework/Spatial"

main :: proc() {
	values := []f32{3, 1, 2}
	fmt.println("smallest/largest/closest:", utility.Smallest(values), utility.Largest(values), utility.GetClosestValue(values, f32(1.6)))
	indices: [dynamic]int = {}
	utility.Triangulate([]spatial.Vec2{{0, 0}, {2, 0}, {2, 2}, {0, 2}}, &indices)
	fmt.println("triangulation:", indices)
	v, ok := utility.ParseVector2("1.5,2.5", ',')
	fmt.println("parse/hash:", v, ok, utility.StaticStringHash("abc"))
}
