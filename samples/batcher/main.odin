package main

import "core:fmt"
import foster "../../Framework"
import graphics "../../Framework/Graphics"
import spatial "../../Framework/Spatial"

batcher: graphics.Batcher

startup :: proc(app: ^foster.App) {
	graphics.BatcherInit(&batcher, &app.GraphicsDevice, "BatcherExample")
	fmt.println("Batcher ready")
}

shutdown :: proc(app: ^foster.App) {
	_ = app
	graphics.BatcherDispose(&batcher)
}

update :: proc(app: ^foster.App) {
	_ = app
}

render :: proc(app: ^foster.App) {
	target := foster.DrawableTargetFromWindow(&app.Window)
	foster.GraphicsDeviceClear(&app.GraphicsDevice, target, foster.Color{24, 28, 36, 255})

	graphics.BatcherClear(&batcher)
	graphics.BatcherRect(&batcher, spatial.Rect{80, 60, 220, 140}, foster.Color{220, 80, 70, 255})
	graphics.BatcherCircle(&batcher, spatial.Vec2{430, 130}, 70, 32, foster.Color{70, 170, 235, 255})
	graphics.BatcherLine(&batcher, spatial.Vec2{80, 260}, spatial.Vec2{560, 300}, 8, foster.Color{245, 205, 70, 255})
	graphics.BatcherRender(&batcher, target)
}

main :: proc() {
	config := foster.DefaultAppConfig("BatcherExample", 640, 360)
	config.WindowTitle = "Foster Odin Batcher"

	app: foster.App
	foster.InitApp(&app, config)
	defer foster.Dispose(&app)

	app.StartupProc = startup
	app.ShutdownProc = shutdown
	app.UpdateProc = update
	app.RenderProc = render
	foster.Run(&app)
}
