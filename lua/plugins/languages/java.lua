local java = vim.fn.exepath("java")
if java == "" and vim.env.JAVA_HOME then
  java = vim.env.JAVA_HOME .. "/bin/java"
end
if vim.fn.executable(java) ~= 1 then
  vim.notify("No se encontro el ejecutable java en PATH o JAVA_HOME", vim.log.levels.ERROR)
  return {}
end

local java_home = vim.fn.fnamemodify(vim.fn.resolve(java), ":h:h")
local jdtls_root = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local path_to_jar = vim.fn.glob(jdtls_root .. "/plugins/org.eclipse.equinox.launcher_[0-9]*.jar")
local path_to_lsp_server = jdtls_root .. "/config_linux"
local lombok = jdtls_root .. "/lombok.jar"
local java_style = vim.fn.stdpath("config") .. "/lang-servers/intellij-java-google-style.xml"
if vim.fn.filereadable(java_style) ~= 1 then
  local existing_style = vim.fn.expand("~/codes/intellij-java-google-style.xml")
  if vim.fn.filereadable(existing_style) == 1 then
    java_style = existing_style
  end
end
local java_format_settings = vim.fn.filereadable(java_style) == 1 and {
  url = java_style,
  profile = "GoogleStyle",
} or {}
local filetypes = { "java", "yaml", "jproperties" }

vim.env.JAVA_HOME = java_home

local function project_root()
  return vim.fs.root(0, {
    "mvnw",
    "gradlew",
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    ".git",
  }) or vim.fn.getcwd()
end

local function capabilities()
  local result = vim.lsp.protocol.make_client_capabilities()
  pcall(function()
    result = require("blink.cmp").get_lsp_capabilities(result)
  end)
  return result
end

return {
  {
    "mfussenegger/nvim-jdtls",
    ft = filetypes,
    dependencies = { "JavaHello/spring-boot.nvim" },
    config = function()
      local jdtls = require("jdtls")
      local spring_boot = require("spring_boot")
      local group = vim.api.nvim_create_augroup("java_jdtls", { clear = true })

      local function start_or_attach()
        local root_dir = project_root()
        local project_name = vim.fn.fnamemodify(root_dir, ":t")
        local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name
        local cmd = {
          java,
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=false",
          "-Dlog.level=WARN",
          "-Xms128m",
          "-Xmx1G",
        }

        if vim.fn.filereadable(lombok) == 1 then
          table.insert(cmd, "-javaagent:" .. lombok)
        end

        vim.list_extend(cmd, {
          "--add-modules=ALL-SYSTEM",
          "--add-opens",
          "java.base/java.util=ALL-UNNAMED",
          "--add-opens",
          "java.base/java.lang=ALL-UNNAMED",
          "-jar",
          path_to_jar,
          "-configuration",
          path_to_lsp_server,
          "-data",
          workspace_dir,
        })

        jdtls.start_or_attach {
          cmd = cmd,
          root_dir = root_dir,
          capabilities = capabilities(),
          settings = {
            java = {
              eclipse = {
                downloadSources = true,
              },
              maven = {
                downloadSources = true,
              },
              configuration = {
                updateBuildConfiguration = "interactive",
                runtimes = {
                  {
                    name = "JavaSE-21",
                    path = java_home,
                    default = true,
                  },
                },
              },
              implementationsCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
              },
              references = {
                includeDecompiledSources = true,
              },
              signatureHelp = {
                enabled = true,
              },
              completion = {
                favoriteStaticMembers = {
                  "org.junit.jupiter.api.Assertions.*",
                  "org.mockito.Mockito.*",
                  "java.util.Objects.requireNonNull",
                  "java.util.Objects.requireNonNullElse",
                },
                importOrder = {
                  "java",
                  "javax",
                  "org",
                  "com",
                },
              },
              sources = {
                organizeImports = {
                  starThreshold = 9999,
                  staticStarThreshold = 9999,
                },
              },
              codeGeneration = {
                toString = {
                  template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                },
                useBlocks = true,
              },
              format = {
                enabled = true,
                settings = java_format_settings,
              },
            },
          },
          flags = {
            allow_incremental_sync = true,
          },
          init_options = {
            bundles = spring_boot.java_extensions(),
            extendedClientCapabilities = jdtls.extendedClientCapabilities,
          },
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "<leader>co", function()
              vim.lsp.buf.code_action { context = { only = { "source.organizeImports" } } }
            end, { buffer = bufnr, desc = "Java: organize imports" })
          end,
        }
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = filetypes,
        callback = start_or_attach,
      })

      if vim.tbl_contains(filetypes, vim.bo.filetype) then
        start_or_attach()
      end
    end,
  },
}
