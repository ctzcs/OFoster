package main

import "core:fmt"
import graphics "../../Framework/Graphics"
import images "../../Framework/Images"
import spatial "../../Framework/Spatial"

main :: proc() {
	b := graphics.BatcherMake()
	graphics.BatcherRect(&b, spatial.Rect{0, 0, 10, 8}, images.Red)
	graphics.BatcherCircleLine(&b, spatial.Vec2{5, 5}, 3, 1, 8, images.White)

	packer := images.PackerMake()
	img := images.ImageMake(4, 4, images.Transparent)
	images.ImageSetPixel(&img, 1, 1, images.White)
	_ = images.PackerAdd(&packer, "one", img)
	packer.PowerOfTwo = true
	out := images.PackerPack(&packer)

	json := `{"atlas":{"size":16,"distanceRange":4},"metrics":{"lineHeight":1.25,"ascender":0.9,"descender":-0.2},"glyphs":[{"unicode":65,"advance":0.6,"planeBounds":{"left":0,"top":-0.8,"right":0.5,"bottom":0.1},"atlasBounds":{"left":1,"top":2,"right":9,"bottom":12}}]}`
	msdf := images.MsdfFontMake(img, transmute([]u8)json)
	fmt.println("triangles:", graphics.BatcherTriangleCount(&b))
	fmt.println("packed pages:", len(out.Pages), "msdf glyphs:", len(msdf.Characters))
}
