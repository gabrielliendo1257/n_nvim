# Neovim config

Distribución personal modular para Neovim 0.12+ (Lua, estilo AstroNvim/LazyVim, sin frameworks).

## Estructura

```
init.lua                  bootstrap de lazy.nvim + carga de config
lua/config/
  options.lua             opciones globales (indent 2, undofile, splits...)
  keymaps.lua             keymaps globales + navegacion de ventanas
  lsp.lua                 keymaps LSP globales (K, gd, <leader>ca...)
  autocmds.lua            autocmds
lua/plugins/              specs de plugins por archivo
lua/plugins/languages/    config LSP por lenguaje
lazy-lock.json            versiones fijadas de plugins
```

## Keymaps principales

| Keymap | Accion |
|---|---|
| `<Space>` | leader |
| `<leader>ff` | Telescope find files |
| `<leader>fg` | Telescope live grep |
| `<leader>fb` | Telescope buffers |
| `<leader>e` | Neo-tree toggle |
| `<leader>gg` | LazyGit |
| `<C-h/j/k/l>` | Navegacion entre ventanas |
| `<C-Up/Down/Left/Right>` | Resize de ventanas |
| `<leader>sv/sh/sc` | Split vertical / horizontal / cerrar |
| `<leader>a`, `<C-e>` | Harpoon: añadir archivo / menu rapido |
| `<leader>1-4` | Harpoon: seleccionar archivo 1-4 |
| `<leader>cf` | Formatear buffer (conform, fallback LSP) |
| `<leader>co` | Java: organizar imports |
| `<leader>ca/cd/cx` | LSP: code action / diagnostics / references |
| `<leader>db/dc/do/di` | DAP: breakpoint / continue / step over / inspect |
| `s/S` | Flash: buscar con preview |
| `ys/ds/cs` | Surround (mini.surround) |
| `]h/[h` | Gitsigns: siguiente/anterior hunk |

## LSPs (Mason + `vim.lsp.enable` nativo 0.12)

| Lenguaje | Server |
|---|---|
| Python | basedpyright + ruff |
| Rust | rust-analyzer |
| Java | jdtls |
| JavaScript / TypeScript | biome |
| Angular | angular-language-server (requiere `node_modules` del proyecto) |

## Binarios manuales (fuera de Mason)

Se instalan fuera del repo y no los reproduce Mason:

### google-java-format (estilo Google para Java)

```sh
mkdir -p ~/.local/share/google-java-format
curl -sL -o ~/.local/share/google-java-format/google-java-format-1.36.1-all-deps.jar \
  "https://github.com/google/google-java-format/releases/download/v1.36.1/google-java-format-1.36.1-all-deps.jar"
```

Crear `~/.local/bin/google-java-format` con:

```sh
#!/usr/bin/env bash
exec java -jar "$HOME/.local/share/google-java-format/google-java-format-1.36.1-all-deps.jar" "$@"
```

`chmod +x ~/.local/bin/google-java-format`. Requiere Java (verificado con OpenJDK 21).

### lazygit

```sh
# ultima version de https://github.com/jesseduffield/lazygit/releases
curl -sL -o /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v0.64.1/lazygit_0.64.1_Linux_x86_64.tar.gz"
tar -xzf /tmp/lazygit.tar.gz -C /tmp
mv /tmp/lazygit ~/.local/bin/lazygit
```

## Notas

- `format_on_save = false` por decision; formatear con `<leader>cf`.
- Treesitter: los parsers se instalan bajo demanda (`lua/plugins/treesitter.lua`); requiere `tree-sitter-cli` (instalado via Mason) para compilar los que falten.
- jdtls: el formateo del LSP esta desactivado a favor de google-java-format.
- biome solo se activa con `biome.json` (o lockfile/.git) en el proyecto.