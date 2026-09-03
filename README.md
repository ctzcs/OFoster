# OFoster

OFoster is an Odin implementation of the [Foster](https://github.com/FosterFramework/Foster)
2D game framework.

## Requirements

- Odin nightly (the project uses the `vendor:sdl3` package shipped with Odin)
- SDL3 runtime available from the Odin distribution

## Foster sync baseline

OFoster is currently synchronized with the upstream Foster source at:

- Upstream: [FosterFramework/Foster](https://github.com/FosterFramework/Foster)
- Foster version: `v0.4.2`
- Source commit: [`06213b9cec2b29c715795a23253595d517ca13d2`](https://github.com/FosterFramework/Foster/commit/06213b9cec2b29c715795a23253595d517ca13d2)
- Commit date: `2026-08-31`
- Release date: `2026-08-27`

The upstream `v0.4.2` line includes API changes after the previous `v0.3.0`
baseline. The Odin port is synchronized against this commit for version
tracking, with the remaining API differences to be ported incrementally.
When synchronizing later, compare upstream changes after this commit and update
this section together with `FosterVersionMajor`, `FosterVersionMinor`, and
`FosterVersionPatch` in `foster_framework.odin`.

The 0.4.2 additions currently exposed by the port include stencil/fill draw
state, texture flags and region operations, compute pipeline/dispatch types,
uniform buffers, storage backends (including Store/Deflate ZIP archives),
convex hull and rectangle difference helpers, and virtual-input
activation/manual-update helpers. The SDL3 bindings supplied with Odin are
used directly.

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
