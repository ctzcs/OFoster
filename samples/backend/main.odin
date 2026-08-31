package main

import "core:fmt"
import "core:os"
import images "../../Framework/Images"
import internal "../../Framework/Internal/ThirdParty"

main :: proc() {
	font_data, err := os.read_entire_file_from_path("C:/Windows/Fonts/AGENCYB.TTF", context.temp_allocator)
	if err != nil {
		fmt.println("font-file-unavailable")
		return
	}
	font := images.FontMake(font_data)
	scale := images.FontGetScale(&font, 24)
	ch := images.FontGetCharacter(&font, 'A', scale)
	bitmap := images.FontRasterize(&font, 'A', scale)
	fmt.println("stb:", internal.StbTrueTypeAvailable(), "metrics:", font.Ascent, font.Descent, "glyph:", ch.GlyphIndex, ch.Width, ch.Height, "pixels:", len(bitmap))
}
