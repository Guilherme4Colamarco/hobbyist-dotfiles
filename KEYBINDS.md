# Keybinds

This file groups the window-manager keybinds by behavior:

- **Works in every WM**: actions that exist in all WMs/compositors in this repo.
- **Shared by most WMs**: actions that are common, but not universal.
- **WM-specific binds**: actions that are unique or notably different per WM.

`Mod` generally means the main modifier key (`Super`/Windows key). Some configs write it as `SUPER` or `mod`.

## Works in every WM

| Action | Niri | MangoWM | Hyprland | DriftWM | Qtile |
|---|---|---|---|---|---|
| Terminal | `Mod+T`, `Mod+Return` | `SUPER+T`, `SUPER+Return` | `SUPER+T`, `SUPER+Return` | `mod+t` | `mod+t` |
| App launcher | `Mod+Space` | `SUPER+Space` | `SUPER+Space` | `mod+space` | `mod+space` |
| Close focused window | `Mod+Q` | `SUPER+Q` | `SUPER+Q` | `mod+q` | `mod+q` |
| Quit WM/compositor | `Mod+Ctrl+E` | `SUPER+CTRL+E` | `SUPER+CTRL+E` | `mod+ctrl+e` | `mod+control+e` |
| Toggle fullscreen | `Alt+M` | `ALT+F` | `ALT+F` / `SUPER+F` | `mod+f` | `mod+f` |
| Volume/media keys | `XF86Audio*`, `Alt+Bracket/Slash` | `XF86Audio*`, `ALT+Bracket/Slash` | `XF86Audio*`, `ALT+Bracket/Slash` | `XF86Audio*` | `XF86Audio*` |
| Brightness keys | `XF86MonBrightness*`, `Alt+'`, `Alt+;` | `XF86MonBrightness*`, `ALT+'`, `ALT+;` | `XF86MonBrightness*`, `ALT+'`, `ALT+;` | `XF86MonBrightness*` | `XF86MonBrightness*` |

## Shared by most WMs

| Action | Niri | MangoWM | Hyprland | DriftWM | Qtile |
|---|---|---|---|---|---|
| Browser | `Mod+B` | `SUPER+B` | `SUPER+B` | `mod+b` | — |
| File manager / Yazi | `Mod+N` | `SUPER+N` | `SUPER+N` | `mod+n` | `mod+n` |
| Music player / cmus | `Mod+X` | `SUPER+X` | `SUPER+X` | `mod+x` | — |
| System monitor / btop | `Mod+G` | `SUPER+G` | `SUPER+G` | — | — |
| Clipboard history | `Mod+C` | `SUPER+C` | `SUPER+C` | — | `mod+h` |
| Power menu | `Mod+P` | `SUPER+P` | `SUPER+P` | — | — |
| Random wallpaper | `Mod+W` | `SUPER+W` | `SUPER+W` | — | — |
| Lock wallpaper | `Alt+L` | `ALT+L` | `ALT+L` | `mod+alt+l` | — |
| Toggle floating | `Mod+V` | `SUPER+V` | `SUPER+V` | — | `mod+v` |
| Focus direction | `Mod+H/J/K/L`, arrows | `SUPER+H/J/K/L` | `SUPER+H/J/K/L`, arrows | gesture/canvas focused | `mod+h/j/k/l` |
| Move window | `Mod+Shift+H/J/K/L`, arrows | `SUPER+Shift+H/J/K/L`, arrows | `SUPER+Shift+H/J/K/L`, arrows | mouse/canvas movement | `mod+shift+h/j/k/l` |
| Workspace 1–9 | `Mod+1..9` | `SUPER+1..9` | `SUPER+1..9` | — | `mod+1..9` |
| Move to workspace 1–9 | `Mod+Shift+1..9` | `SUPER+Shift+1..9` | `SUPER+Shift+1..9` | — | `mod+shift+1..9` |
| Full screenshot | `Print`, `Mod+Ctrl+S`, `Alt+Period` | `Print`, `SUPER+Ctrl+S`, `ALT+Period` | `Print`, `SUPER+Ctrl+S`, `ALT+Period` | `Print` | `mod+s` |
| Area screenshot | `Alt+Print`, `Mod+Ctrl+R`, `Alt+Comma` | `Alt+Print`, `SUPER+Ctrl+R`, `ALT+Comma` | `Alt+Print`, `SUPER+Ctrl+R`, `ALT+Comma` | `mod+Print` | — |
| Screen recorder | `Ctrl+Print`, `Mod+Shift+R` | `Ctrl+Print`, `SUPER+Shift+R` | `Ctrl+Print`, `SUPER+Shift+R` | — | — |
| Poweroff | `Alt+O` | `ALT+O` | `ALT+O` | `mod+alt+o` | — |
| Reboot | `Alt+R` | `ALT+R` | `ALT+R` | `mod+alt+r` | — |
| Suspend | `Alt+S` | `ALT+S` | `ALT+S` | `mod+alt+s` | — |

## WM-specific binds

### Niri

Source: `Configs/niri/Keybinds.kdl`

| Key | Action |
|---|---|
| `Mod+O` | Toggle overview |
| `Mod+WheelScrollDown/Up` | Focus workspace down/up |
| `Mod+Ctrl+WheelScrollDown/Up` | Move column to workspace down/up |
| `Mod+WheelScrollRight/Left` | Focus column right/left |
| `Mod+Ctrl+WheelScrollRight/Left` | Move column right/left |
| `Mod+BracketLeft` | Consume or expel window left |
| `Mod+BracketRight` | Consume or expel window right |
| `Mod+Comma` | Consume window into column |
| `Mod+Period` | Expel window from column |
| `Mod+0` | Reset window height |
| `Mod+F` | Maximize column |
| `Alt+F` | Maximize column to edges |
| `Alt+A` | Expand column to available width |
| `Mod+-` / `Mod+=` | Set column width down/up |
| `Mod+Shift+-` / `Mod+Shift+=` | Set window height down/up |
| `Ctrl+V` | Switch focus between floating and tiling |
| `Mod+Delete` | Wipe clipboard history (`cliphist wipe`) |
| `Mod+Alt+B` | Open `brave-origin-beta` |

### MangoWM

Source: `Configs/mango/Keybinds.conf`

| Key | Action |
|---|---|
| `SUPER+TAB` | Switch layout |
| `ALT+M` | Toggle fake fullscreen |
| `ALT+Z` | Reload MangoWM config |
| `ALT+I` | Minimize focused window |
| `ALT+U` | Restore minimized window |
| `ALT+Space` | Toggle scratchpad |
| `SUPER+Up/Down` | Navigate workspace/tag |
| `ALT+Up/Down` | Navigate workspace/tag variant |
| `CTRL+SUPER+Left/Right` | Move tag left/right |
| `CTRL+SHIFT+Arrows` | Move window |
| `CTRL+ALT+Arrows` | Resize window |
| `SUPER+Shift+Arrows` / `SUPER+Shift+H/J/K/L` | Exchange client with neighbor |
| `SUPER+Delete` | Wipe clipboard history (`cliphist wipe`) |
| `mousebind SUPER + buttons` | Move/resize windows with mouse |
| `switchbind fold/unfold` | Suspend + lock / wake display behavior |

### Hyprland

Source: `Configs/hypr/hyprland.lua`

| Key | Action |
|---|---|
| `SUPER+O` | Show notification that overview is not supported |
| `SUPER+P` | Open quickshell power menu |
| `SUPER+Grave` | Swap focused window with master |
| `SUPER+Tab` | Focus next window |
| `ALT+Space` | Toggle special workspace `magic` |
| `ALT+Shift+Space` | Move window to special workspace `magic` |
| `SUPER+mouse_down/up` | Navigate workspaces |
| `SUPER+mouse:272` | Move window with mouse |
| `SUPER+mouse:273` | Resize window with mouse |
| `SUPER+BracketLeft/Right` | Layout consume/expel-style actions |
| `SUPER+Comma/Period` | Layout consume/expel-style actions |
| `SUPER+Delete` | Wipe clipboard history (`cliphist wipe`) |
| `SUPER+Ctrl+E` | Exit via `hyprshutdown`/`hyprctl` fallback |

### DriftWM

Source: `Configs/driftwm/config.toml`

DriftWM is canvas/viewport-oriented, so many binds do not map directly to tiling WM actions.

| Key | Action |
|---|---|
| `mod+h` | Home toggle |
| `mod+m` | Fit window |
| `mod+c` | Center window |
| `mod+o` | Zoom to fit |
| `mod+alt+c` | Reverse cycle windows |
| `mod+equal` | Zoom in |
| `mod+minus` | Zoom out |
| `mod+0` | Reset zoom |
| `mod+z` | Reload |
| `mod+ctrl+l` | Lock with `hyprlock` |
| mouse/gesture binds | Move, resize, pan viewport, zoom, navigate canvas |

### Qtile

Source: `Configs/qtile/config.py`

| Key | Action |
|---|---|
| `mod+space` | Next window focus / app launcher depending binding order |
| `mod+shift+Return` | Toggle split |
| `mod+Tab` | Next layout |
| `mod+n` | Normalize window sizes / launch Yazi depending binding order |
| `mod+shift+r` | Reload Qtile config |
| `mod+control+h/j/k/l` | Grow window left/down/up/right |
| `ctrl+mod+f1..f7` | Switch virtual terminal on Wayland |
| `mod+h` | Focus left / clipboard depending duplicate binding order |
| `mod+s` | Screenshot via Flameshot |

## Notes

- Some WMs have duplicate or overlapping binds. In those cases, the effective behavior depends on how that WM resolves duplicate key definitions.
- Clipboard history depends on `cliphist` and `wl-clipboard` being running/configured.
- Screenshot and recording binds call scripts in `~/.config/Scripts/`.
- Niri output and keyboard settings are configured separately in `Configs/niri/Outputs.kdl` and `Configs/niri/Input.kdl`.
