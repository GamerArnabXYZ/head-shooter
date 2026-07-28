# Head Shooter — Minecraft-Styled Bubble Shooter (Godot 3.5)

A mobile-first, square-grid bubble-shooter. Shoot mob heads from the cannon,
match 3+ of the same type to pop them. Built for **Godot 3.5.x** (GLES2)
so it runs on low-end Android phones and exports to WebGL 1.0 for old
browsers/devices too.

## Project layout

```
project.godot           Engine config (GLES2, portrait 720x1280, autoload)
export_presets.cfg      Android + Web(HTML5) export presets — used by CI
default_env.tres        Minimal render environment
icon.png                App icon

autoload/Globals.gd      Singleton: head types, textures, grid constants, save/load

scenes/home/             Home screen (Start / High Score / Settings / Quit)
scenes/game/              Game.tscn (root) + Game.gd (HUD/flow) + GridManager.gd (board logic)
scenes/cannon/            Cannon.tscn/gd — aim + fire (touch AND mouse)
scenes/head/              Head.tscn/gd — one mob head (grid cell OR flying shot)

theme/GameTheme.tres     Blocky/pixelated global UI theme (buttons, panels)
assets/heads/*.png       Steve / Creeper / Zombie / Skeleton placeholder art
assets/ui/cannon.png     Cannon turret placeholder art

.github/workflows/build.yml   CI: builds Android APK + Web build on every push
```

**Note on art:** the head/cannon PNGs are small **original** pixel-art
placeholders I generated (not Mojang/Minecraft's actual copyrighted
textures) — safe to ship as-is, or swap your own 128×128 PNGs into
`assets/heads/` and `assets/ui/` any time. No code changes needed.

## Design notes (things worth knowing before you tweak it)

- **Grid is square** (not hex) — 8 columns × 90px cells, 4-directional
  match adjacency. This was a deliberate simplification for reliability
  since you can't step through it in the editor on-device; a hex grid
  has more edge cases. Fully playable and looks fine.
- Every 8 shots, a new row pushes in from the top (classic bubble-shooter
  difficulty ramp). Board clears → "BOARD CLEARED"; a head crosses
  `Globals.DANGER_ROW` → "GAME OVER".
- Cannon aiming works with `InputEventScreenTouch/Drag` (Android) AND
  `InputEventMouseButton/Motion` (Web/desktop) in the same code path.
- High score is saved to `user://savegame.save` (JSON) via Globals.gd.
- All touch targets (buttons) are ≥90px tall — comfortable thumb size.

## How to push this from your phone (Termux, no PC)

```bash
# one-time setup
pkg install git -y
git config --global user.name "GamerArnabXYZ"
git config --global user.email "you@example.com"

# from inside the unzipped HeadShooter folder
cd HeadShooter
git init
git add .
git commit -m "Initial commit: Head Shooter v1"
git branch -M main
git remote add origin https://github.com/<your-username>/<your-repo>.git
git push -u origin main
```

If prompted for a password, GitHub needs a **Personal Access Token**
(Settings → Developer settings → Personal access tokens → generate one
with `repo` scope) — paste that as the password.

## Getting your builds

1. Push → go to your repo's **Actions** tab → open the running workflow.
2. When it finishes (green check), scroll to **Artifacts**:
   - `HeadShooter-Android-APK` → download, unzip, install the `.apk` on
     your phone (enable "install unknown apps" once).
   - `HeadShooter-Web` → download, unzip, and either open `index.html`
     locally or host the folder (GitHub Pages / Netlify / itch.io) to
     play in-browser.

## Customizing quickly

- Add a 5th mob type: add an entry to `Globals.HeadType` enum, add its
  texture to `Globals.HEAD_TEXTURES`, generate/drop in a PNG.
- Change difficulty: `GridManager.gd` → `shots_per_new_row`, `start_rows`,
  `Globals.DANGER_ROW`.
- Change cannon speed/feel: `Cannon.gd` → `speed`, `MIN_ANGLE_MARGIN`.
