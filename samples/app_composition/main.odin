package main

import "core:fmt"
import foster "../../Framework"

Game :: struct {
	App: foster.App,
	Score: int,
}

startup :: proc(app: ^foster.App) {
	game := cast(^Game)foster.AppGetUserData(app)
	game.Score = 1
	fmt.println("startup score:", game.Score)
}

main :: proc() {
	game := Game{}
	foster.AppSetUserData(&game.App, rawptr(&game))
	game.App.StartupProc = startup
	fmt.println("App composition is ready")
}
