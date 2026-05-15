# Plano de tarefa: Installer interativo para fork dos dotfiles

## Objetivo

Criar uma base para um fork dos dotfiles com um installer interativo/TUI inspirado no `inir`, capaz de:

- perguntar o que o usuário quer instalar;
- detectar pacotes/ferramentas já instalados no sistema;
- oferecer opções adicionais de pacotes, incluindo Brave, Firefox, Zen Browser e Helium;
- lidar melhor com conflitos conhecidos, como `niri` vs `niri-git` e `timeshift` vs Snapper;
- preparar uma estrutura extensível para perfis, idiomas e escolhas regionais.

## Restrições e cuidados

- Não fazer commit sem pedido explícito.
- Evitar remover suporte existente sem alternativa.
- Preservar o fluxo não interativo quando possível.
- Registrar descobertas em `findings.md` após pesquisa.
- Registrar mudanças em `progress.md` após cada modificação significativa.

## Fases

### Fase 1 — Mapear estado atual

Status: completo

- Ler `install.sh`.
- Ler `Configs/installed-pkg/pkglist.txt`.
- Localizar aliases/scripts que dependem de Timeshift, browser ou pacote específico.
- Identificar padrões atuais de estilo shell.

### Fase 2 — Desenhar solução do installer

Status: completo

- Escolher abordagem TUI simples em shell puro, com fallback sem dependências.
- Definir categorias: base, WM/compositor, browser, snapshot, extras.
- Definir detecção de pacotes já instalados.
- Definir tratamento de conflitos.

### Fase 3 — Implementar primeira versão

Status: completo

- Refatorar `install.sh` com prompts interativos.
- Adicionar helpers para detecção de pacotes e confirmação.
- Separar listas opcionais quando necessário.
- Incluir Brave, Firefox, Zen e Helium como opções de browser.

### Fase 4 — Ajustar docs/plano de contribuição

Status: completo

- Documentar o fluxo interativo.
- Atualizar plano de idioma/perfis se necessário.

### Fase 5 — Verificação

Status: completo

- Rodar `bash -n install.sh`.
- Revisar diff.
- Validar que não há comandos destrutivos automáticos sem prompt.

### Fase 6 — Customização persistente do setup

Status: planejado

- Criar fonte única de preferências do usuário para browser, WM, snapshot e serviços.
- Fazer o installer carregar, usar como default nos prompts e salvar esse perfil.
- Trocar binds/aliases hardcoded por wrappers que leem o perfil.
- Aplicar defaults XDG do browser escolhido em etapa pós-stow/apply-profile.
- Manter idempotência, dry-run e preview antes de alterar sistema/configs.

## Decisões abertas

- Nome final do fork/projeto.
- Se o installer deve instalar tudo por padrão ou partir de perfil mínimo.
- Se Helium deve ser instalado por pacote AUR, Flatpak ou wrapper existente.
- Formato final do perfil persistente: shell `profile.conf` simples ou TOML com parser/helper.
- Se os WMs devem chamar sempre wrappers (`preferred-browser`) ou se haverá geração de fragmentos específicos por WM.
