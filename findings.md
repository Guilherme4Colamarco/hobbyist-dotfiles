# Descobertas

## Contexto inicial

- Repositório: `/home/geko/hobbyist-dotfiles`.
- O usuário quer evoluir os dotfiles para um fork com installer interativo/TUI.
- Deve perguntar escolhas ao usuário e detectar estado instalado.
- Browsers desejados como opções: Brave normal, Firefox, Zen e Helium; o usuário usa Helium.
- Conflitos já observados na sessão:
  - `niri` vs `niri-git`.
  - `timeshift` vs Snapper/CachyOS.
- Alterações anteriores não commitadas incluem configs de WMs, Fastfetch logos, docs e backup local.

## Pesquisas

### Installer e lista atual

- `install.sh` é linear e não interativo.
- Fluxo atual:
  - instala base com `sudo pacman -S --needed --noconfirm base-devel stow fish eza git`;
  - instala `yay-bin` se `yay` não existir;
  - aplica Stow, copia fontes/wallpapers;
  - instala tudo de `Configs/installed-pkg/pkglist.txt` via `xargs yay -S --needed ... --noconfirm`;
  - troca shell para Fish;
  - instala/ativa Bluetooth;
  - ativa `niri.service` e `mako-sound.service` se existirem;
  - clona/instala WhiteSur icon theme.
- `Configs/installed-pkg/pkglist.txt` mistura pacotes base, browsers, WMs, extras e ferramentas de snapshot em uma lista única.
- Pacotes relevantes já na lista:
  - browser: `brave-origin-beta-bin`, `librewolf-bin`;
  - snapshot: `timeshift`;
  - compositor: `niri-git`, `mangowm-git`;
  - TUI/helper: `fzf`, `bluetui`, `yazi`.
- O conflito `niri` vs `niri-git` está documentado em `docs/package-conflicts.md`.

### Recomendações do mapeamento

- Separar a instalação por categorias em vez de instalar `pkglist.txt` inteiro.
- Promptar escolha de browser, snapshot tool e compositor antes da instalação em massa.
- Detectar pacotes existentes com `pacman -Q` antes de instalar/remover.
- Tratar `timeshift` vs Snapper e `niri` vs `niri-git` antes de chamar `yay -S`.
- Usar TUI simples em shell puro/fzf, alinhado ao estilo já presente no repo (`nmtui`, `bluetui`, `yazi`).

### Aliases Fish e snapshots

- `Configs/fish/config.fish` usa Timeshift diretamente:
  - `pacup='sudo timeshift --create --comments "Before update" --tags O && yay -Syu'`;
  - `ts`, `tsd`, `tsl` e alias `timeshift='sudo timeshift-gtk'`.
- Se o perfil CachyOS/Snapper for preferido, esses aliases precisam de alternativa ou documentação.

### Pacotes opcionais confirmados no sistema/repositórios

- `snapper` está instalado.
- `helium-browser-bin` está instalado.
- `timeshift` está disponível, mas conflita com o cenário CachyOS/Snapper do usuário.
- Browsers encontrados:
  - `brave-bin` — Brave estável/normal;
  - `firefox` — Firefox estável;
  - `zen-browser-bin` — Zen Browser;
  - `helium-browser-bin` — Helium Browser.
- A lista atual usa `brave-origin-beta-bin`, mas para a opção “Brave normal” o pacote correto neste ambiente é `brave-bin`.

### Revisão da primeira implementação do installer

- `install.sh` foi refatorado pelo @fixer para TUI shell-only com escolhas de browsers, compositor, snapshot, serviços e WhiteSur.
- Validação sintática `bash -n install.sh` passou na execução do @fixer.
- Problemas detectados na revisão:
  - o bit executável de `install.sh` mudou de `100755` para `100644`;
  - a seleção de core packages ainda instalaria core mesmo se o usuário respondesse “não”;
  - WhiteSur seria instalado automaticamente em `DOTFILES_ASSUME_YES=1` apesar de ser opcional com default seguro “não”;
  - Bluetooth era habilitado antes da instalação dos pacotes selecionados;
  - Librewolf foi excluído antes de poder entrar na lista opcional.

### Correções após revisão

- Core packages agora são instalados com `sudo pacman -S` antes do bootstrap do `yay`, garantindo `git`/`base-devel` para clonar e compilar `yay-bin`.
- `CORE_PKGS` saiu da instalação em massa via `yay` para evitar duplicação.
- O `stow-configs.sh` só roda após a etapa de core, então `stow` tende a existir antes da aplicação dos dotfiles.

### Revisão @oracle e correções de segurança

- Adicionado bloqueio para não executar o installer como root/sudo diretamente.
- `pacman/yay -S --noconfirm` agora só é usado em `DOTFILES_ASSUME_YES=1`; em modo interativo, pacman/yay podem perguntar sobre conflitos.
- Se `niri` estiver instalado e o usuário não autorizar remoção, `niri-git` é removido da seleção para não tentar resolver conflito depois.
- Serviços de usuário (`niri`, `mako-sound`) agora são habilitados após a instalação de pacotes, com aviso em falha.
- Troca para Fish agora é um prompt separado e verifica `/etc/shells`.
- Cópia de fontes/wallpapers mudou para `cp -rn` para evitar sobrescrever arquivos existentes.
- `bootstrap_yay` garante `git` e `base-devel` antes de compilar `yay-bin` se necessário.

### MangoWM config ativa

- `~/.config/mango/Monitors.conf` é symlink para `/home/geko/hobbyist-dotfiles/Configs/mango/Monitors.conf`.
- `Configs/mango/config.conf` carrega `source=./Monitors.conf`, então a config ativa de monitor é esse `Monitors.conf` do repo.

### Reunião subagentes — setup mais customizável

- @explorer confirmou que o installer já é shell-only interativo e separa categorias, mas ainda há acoplamento em `pkglist.txt`, `install.sh`, binds de WMs e aliases Fish.
- Hardcodes principais de browser:
  - `Configs/mango/Keybinds.conf`: `librewolf`, `brave-origin-beta`, YouTube via Brave beta.
  - `Configs/hypr/hyprland.lua`: `librewolf`, `brave-origin-beta` e YouTube via Brave beta.
  - `Configs/niri/Keybinds.kdl`: `librewolf`, `brave`/`brave-origin-beta`.
  - `Configs/driftwm/config.toml`: `mod+b = exec librewolf`.
- XDG default pode estar em Helium, mas atalhos dos WMs ignoram XDG quando chamam executáveis hardcoded.
- @oracle recomendou fonte única de preferências em `~/.config/hobbyist-dotfiles/profile.conf` ou equivalente, com campos como browser, desktop file, comando, WM, snapshot e serviços.
- Recomendação arquitetural incremental: criar wrappers versionados em `Configs/Scripts/`, como `preferred-browser`, `preferred-browser-youtube`, `snapshot-create`, `snapshot-list`, `snapshot-delete` e `snapshot-before-update`.
- WMs deveriam chamar wrappers em vez de `librewolf`/`brave-origin-beta`; aliases Fish deveriam chamar wrappers de snapshot em vez de Timeshift direto.
- Evitar `sed`/patch textual em configs stowadas; risco de editar symlink para o repo e dificultar rollback.
- Etapa `apply-profile` pós-stow deve aplicar XDG defaults (`xdg-settings`/`xdg-mime`) e gerar apenas arquivos seguros/idempotentes quando necessário.
- @designer recomendou fluxo de setup em duas camadas: modo rápido com perfil + 3 escolhas principais, e modo avançado com pacotes/conflitos/preview detalhado.
- Defaults seguros propostos: browser `Sistema atual / não alterar`, WM `Manter atual`, snapshot `Manter atual` ou `Nenhum`, WhiteSur `Não`, e não remover nada sem confirmação explícita.
- Preview antes de aplicar deve mostrar instalar/pular/conflitos/serviços/arquivos afetados/binds e aliases afetados.

### Grafo estrutural antes da fragmentação

- A estrutura atual tem dois orquestradores principais: `install.sh` para instalar/configurar e `stow-configs.sh` para aplicar arquivos em `~/.config`.
- `Configs/mango/config.conf` e `Configs/niri/config.kdl` já funcionam como entrypoints modulares com `source=`/`include`; são bons modelos para fragmentar outros WMs.
- `Configs/hypr/hyprland.lua`, `Configs/driftwm/config.toml` e `Configs/qtile/config.py` são mais monolíticos: misturam binds, autostart, regras/layouts e comandos específicos.
- `Configs/installed-pkg/pkglist.txt` continua sendo pacote monolítico, misturando base, WMs, browsers, snapshot e extras.
- Acoplamentos importantes para fragmentar depois: browser hardcoded em WMs, snapshot hardcoded no Fish, paths repetidos para Scripts/Waybar/Rofi, e lógica de seleção hardcoded no `install.sh`.

### Wlogout / power menu quebrado

- `Configs/wlogout/style.css` referenciava ícones absolutos em `/home/blackspark/.config/wlogout/icons/*.png`; no usuário atual esses arquivos não existem.
- O sintoma visual eram faixas/vermelhos de imagem quebrada/placeholder nos botões do power menu.
- Ícones corretos existem em `Configs/wlogout/icons/` e estão disponíveis via `~/.config/wlogout/icons/` após Stow.
- Corrigido `style.css` para apontar para `/home/geko/.config/wlogout/icons/*.png` e simplificar os botões com tema escuro/Nord, bordas arredondadas e hover/focus mais legíveis.
