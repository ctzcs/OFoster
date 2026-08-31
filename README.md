# OFoster

OFoster is an Odin implementation of the [Foster](https://github.com/FosterFramework/Foster)
2D game framework.

## Requirements

- Odin nightly (the project uses the `vendor:sdl3` package shipped with Odin)
- SDL3 runtime available from the Odin distribution

The repository root is the OFoster library package. Runnable examples are
maintained in the separate `OFoster_Sample` project.

## Use the framework

Import the OFoster root package from an Odin program. When building from the repository root,
define the collection once:

```odin
import foster "ofoster:."
```

The package mirrors Foster's public concepts: `App`, `Window`, `GraphicsDevice`,
`Texture`, `Target`, `Shader`, `Material`, `Mesh`, input bindings, spatial
primitives, storage helpers, and utility functions. Framework source files and
public subpackages live at the repository root.

## App usage

Odin does not have C#-style class inheritance. Use composition: put an `App`
inside your game state, register lifecycle procedures, and attach the state with
`AppSetUserData` when callbacks need access to it.

```odin
package main

import foster "ofoster:."

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
`^foster.App` argument directly, as shown in the `OFoster_Sample` project.
