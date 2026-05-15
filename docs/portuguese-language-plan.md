# Portuguese language contribution plan

Goal: make these dotfiles friendly for Portuguese-speaking users while keeping English as a safe default.

## 1. Translation scope

Start with user-facing text only:

- `README.md`
- `KEYBINDS.md`
- install messages in `install.sh`
- troubleshooting docs under `docs/`

Avoid translating config keys, commands, package names, and paths.

## 2. Repository structure

Recommended layout:

```text
README.md                 # English default
README.pt-BR.md           # Portuguese translation
KEYBINDS.md               # English default
KEYBINDS.pt-BR.md         # Portuguese translation
docs/
  package-conflicts.md
  package-conflicts.pt-BR.md
```

## 3. Language selection option

Add an installer language selector:

```text
Select language / Selecione o idioma:
1) English
2) Português Brasil
```

Implementation idea:

- create `Configs/install/lang/en.sh`
- create `Configs/install/lang/pt_BR.sh`
- each file exports the same message variables;
- `install.sh` loads one language file based on `DOTFILES_LANG`, system locale, or user prompt.

Suggested priority order:

1. `DOTFILES_LANG=pt_BR bash install.sh`
2. detected locale from `$LANG`
3. interactive prompt fallback
4. English if detection fails

## 4. Keyboard/display profiles

Add selectable regional profiles instead of hardcoding one setup for everyone:

```text
Configs/profiles/
  en-US/
    keyboard.env
  pt-BR/
    keyboard.env
```

Example `pt-BR/keyboard.env`:

```sh
XKB_LAYOUT=br
XKB_VARIANT=abnt2
MONITOR_MODE=1920x1080@165
```

Then generate or patch compositor configs from the selected profile.

## 5. Contribution checklist

- Keep English and Portuguese docs in sync.
- Use `pt-BR` naming consistently.
- Include screenshots only when language-specific UI changes.
- Test installer messages with both `DOTFILES_LANG=en` and `DOTFILES_LANG=pt_BR`.
- Document manual override commands for keyboard layout and refresh rate.
