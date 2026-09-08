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
| `<leader>tr/tR/ts/to/tx` | Neotest: run test / run file / stop / output / summary |
| `<leader>sr/sx` | Spring Boot: iniciar / detener el servicio del proyecto |
| `s/S` | Flash: buscar con preview |
| `ys/ds/cs` | Surround (mini.surround) |
| `]h/[h` | Gitsigns: siguiente/anterior hunk |

## LSPs (Mason + `vim.lsp.enable` nativo 0.12)

| Lenguaje | Server |
|---|---|
| Python | basedpyright + ruff |
| Rust | rust-analyzer |
| Java | jdtls |
| Spring Boot | Spring Boot Language Server + jdtls |
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

### lombok (soporte Lombok en jdtls)

Mason instala `lombok.jar` junto con jdtls. La config de `java.lua` añade `-javaagent:<lombok.jar>` al comando de jdtls automáticamente si el jar existe.

### Spring Boot Language Server

Instalar una vez desde Mason:

```vim
:MasonInstall vscode-spring-boot-tools
```

Al abrir Java, `application.yml` o `application.properties`, se activa el soporte de Spring Boot: completado y navegacion de propiedades, beans, endpoints y code actions. `java.lua` habilita jdtls para esos tres filetypes para que el servidor Spring pueda cargar el classpath. Requiere Java 21+.

`<leader>sr` ejecuta `./mvnw spring-boot:run` o `./gradlew bootRun` segun el proyecto; `<leader>sx` lo detiene. Tambien estan disponibles `:SpringBootRun` y `:SpringBootStop`.

### JUnit Platform Console (tests Java con neotest-java)

Primera vez (descarga el jar con verificación SHA-256 a `~/.local/share/nvim/neotest-java/`):

```vim
:NeotestJava setup
```

Requisitos: jdtls activo en el proyecto (lo habilita `java.lua` al abrir Java, YAML o properties). Soporta Maven/Gradle, JUnit 5 y Spring.

### lazygit

El ejecutable se instala como paquete del sistema en Arch Linux:

```sh
sudo pacman -S lazygit
```

La integracion de Neovim esta en `lua/plugins/lazygit.lua` y `lua/plugins/toggleterm.lua`:

- `<leader>gg`: Lazygit en ventana flotante.
- `<leader>gl`: cambios del proyecto.
- `<leader>gf`: cambios del archivo actual.
- `<leader>tl`: Lazygit en un terminal flotante persistente.

Si existe una copia en `~/.local/bin/lazygit`, esa ruta tiene prioridad sobre `/usr/bin/lazygit` en el `PATH`. Renombrala o retirala despues de instalar el paquete si quieres usar exclusivamente la version de pacman.

## Notas

- `format_on_save = false` por decision; formatear con `<leader>cf`.
- Treesitter: los parsers se instalan bajo demanda (`lua/plugins/treesitter.lua`); requiere `tree-sitter-cli` (instalado via Mason) para compilar los que falten.
- Conform usa `google-java-format` con `<leader>cf`; jdtls conserva sus reglas de formato para las funciones del servidor.
- biome solo se activa con `biome.json` (o lockfile/.git) en el proyecto.
