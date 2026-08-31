# OFoster

OFoster is an Odin implementation of the [Foster](https://github.com/FosterFramework/Foster)
2D game framework.

## Requirements

- Odin nightly (the project uses the `vendor:sdl3` package shipped with Odin)
- SDL3 runtime available from the Odin distribution

## Run the examples

From this directory:

```bat
run.bat
```

This runs `samples/basic`. Other examples can be selected by name:

```bat
run.bat feature
run.bat batcher
run.bat spatial
run.bat calc
run.bat backend
run.bat app_composition
```

The source for every runnable example lives under `samples`; `build` contains
only generated executables and test output.

The `basic` example keeps its update/render loop running until the window is
closed. SDL close events are handled by `App`, which sets the application to
exit cleanly.

## Use the framework

Import `Framework` from an Odin program:

```odin
import foster "path/to/OFoster/Framework"
```

The package mirrors Foster's public concepts: `App`, `Window`, `GraphicsDevice`,
`Texture`, `Target`, `Shader`, `Material`, `Mesh`, input bindings, spatial
primitives, storage helpers, and utility functions. The package source lives in
the `Framework` directory.

## App usage

Odin does not have C#-style class inheritance. Use composition: put an `App`
inside your game state, register lifecycle procedures, and attach the state with
`AppSetUserData` when callbacks need access to it.

```odin
package main

import foster "path/to/OFoster/Framework"

Game :: struct {
    App: foster.App,
    Score: int,
}

startup :: proc(app: ^foster.App) {
    game := cast(^Game)foster.AppGetUserData(app)
    game.Score = 0
}

update :: proc(app: ^foster.App) {
    game := cast(^Game)foster.AppGetUserData(app)
    game.Score += 1
    if app.Time.Frame >= 60 {
        foster.Exit(app)
    }
}

main :: proc() {
    game := Game{}
    config := foster.DefaultAppConfig("MyGame", 1280, 720)
    foster.InitApp(&game.App, config)
    defer foster.Dispose(&game.App)

    foster.AppSetUserData(&game.App, rawptr(&game))
    game.App.StartupProc = startup
    game.App.UpdateProc = update
    foster.Run(&game.App)
}
```

For a small program with no custom state, the callbacks can simply use the
`^foster.App` argument directly, as shown in `samples/basic/main.odin`.
