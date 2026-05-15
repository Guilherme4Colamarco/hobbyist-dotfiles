# Progresso

## 2026-05-14

### Inicialização do planejamento

- Criados `task_plan.md`, `findings.md` e `progress.md` na raiz do projeto.
- Motivo: tarefa é complexa e o usuário pediu explicitamente planejamento persistente em arquivos.
- Próximo passo: mapear `install.sh`, `pkglist.txt` e dependências relacionadas a Timeshift/browser/conflitos.

### Fase 1 — pesquisa inicial

- Lidos `install.sh` e `Configs/installed-pkg/pkglist.txt`.
- Delegado mapeamento para @explorer sobre installer, package aliases e padrões TUI.
- Descobertas registradas em `findings.md` conforme regra das 2 ações.
- Próximo passo: inspecionar aliases Fish e confirmar nomes de pacotes opcionais de browsers/snapshot.

### Fase 1 — aliases e pacotes opcionais

- Lidos `Configs/fish/config.fish` e `Configs/fish/functions/clean.fish`.
- Confirmados pacotes opcionais por busca no gerenciador disponível: `brave-bin`, `firefox`, `zen-browser-bin`, `helium-browser-bin`, `snapper`, `timeshift`.
- `snapper` e `helium-browser-bin` aparecem instalados no sistema atual.
- Próximo passo: desenhar implementação e refatorar `install.sh`.

### Fase 3 — primeira implementação delegada

- @fixer refatorou `install.sh` para installer interativo e atualizou `README.md`.
- Revisão local encontrou ajustes necessários antes de considerar a fase completa.
- Próximo passo: corrigir seleção de core, comportamento non-interactive seguro, ordem de Bluetooth, Librewolf opcional e permissão executável.

### Fase 3 — correções locais do installer

- Corrigida instalação de core packages para acontecer via `pacman` antes do bootstrap do `yay`.
- Removida duplicação de core packages na instalação final via `yay`.
- Mantido `install.sh` executável.
- Próximo passo: rodar validação sintática e revisar diff final.

### Fase 5 — revisão e validação

- @oracle revisou segurança/correção do installer e apontou riscos altos/médios.
- Corrigidos os principais riscos altos: root guard, `--noconfirm` apenas em modo non-interactive, conflito `niri`/`niri-git`, ordem de serviços e prompt de shell.
- Corrigidos riscos médios selecionados: `cp -rn`, cleanup de tmpdir, parser ignorando comentários e bootstrap de prerequisitos do `yay`.
- Validações executadas:
  - `bash -n install.sh` OK;
  - `test -x install.sh` OK;
  - `git diff --check -- install.sh README.md task_plan.md findings.md progress.md` OK.

### MangoWM — config ativa

- Confirmado que `~/.config/mango/Monitors.conf` aponta para `Configs/mango/Monitors.conf` neste repositório.
- Confirmado que `Configs/mango/config.conf` inclui `source=./Monitors.conf`.
- Próximo passo: verificar conteúdo ativo e garantir `refresh:165`.

### Reunião subagentes — customização no setup

- Delegados três pontos de vista:
  - @explorer: mapeou installer, `pkglist`, binds de browser e aliases.
  - @oracle: propôs arquitetura com perfil persistente, wrappers e etapa `apply-profile`.
  - @designer: propôs UX/TUI com defaults seguros, preview, modo rápido e modo avançado.
- Decisão preliminar: priorizar wrappers e fonte única de preferências antes de templates/patches de configs.
- Próximo passo: implementar `Profiles/example.conf` ou equivalente, wrappers `preferred-browser*` e substituir binds hardcoded dos WMs.

### Grafo da estrutura dos arquivos

- @explorer mapeou a estrutura de alto nível do repositório e relações entre installer, Stow, configs por WM, scripts, package list, Fish e docs.
- Registrado em `findings.md` que Mango/Niri já são modularizados e podem servir de modelo, enquanto Hypr/DriftWM/Qtile e `pkglist.txt` seguem mais monolíticos.
- Próximo passo: usar o grafo estrutural para planejar a fragmentação sem alterar comportamento.

### Correção do power menu / wlogout

- Corrigido `Configs/wlogout/style.css`, que ainda apontava ícones para `/home/blackspark`.
- Substituído visual quebrado por tema escuro translúcido com botões arredondados, ícones em `/home/geko/.config/wlogout/icons/` e estados hover/focus.
- Verificado que `~/.config/wlogout/style.css` reflete a alteração e que os ícones existem.
