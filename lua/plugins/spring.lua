local terminals = {}

local function project_root()
  return vim.fs.root(0, { "pom.xml", "mvnw", "gradlew", "build.gradle", "build.gradle.kts" }) or vim.uv.cwd()
end

local function current_spring_terminal()
  local _, term = require("toggleterm.terminal").identify()
  if term and term.spring_root then
    return term.spring_root, term
  end
end

local function has_file(root, name)
  return vim.fn.filereadable(root .. "/" .. name) == 1
end

local function spring_command(root, extra_args)
  local command
  if has_file(root, "mvnw") then
    command = "./mvnw spring-boot:run"
  elseif has_file(root, "pom.xml") then
    command = "mvn spring-boot:run"
  elseif has_file(root, "gradlew") then
    command = "./gradlew bootRun"
  elseif has_file(root, "build.gradle") or has_file(root, "build.gradle.kts") then
    command = "gradle bootRun"
  else
    return nil
  end

  if extra_args and extra_args ~= "" then
    command = command .. " " .. extra_args
  end
  return command
end

local function job_running(term)
  return term.job_id and vim.fn.jobwait({ term.job_id }, 0)[1] == -1
end

local function run(extra_args)
  local root = current_spring_terminal() or project_root()
  local command = spring_command(root, extra_args)
  if not command then
    vim.notify("No se encontro Maven ni Gradle en este proyecto", vim.log.levels.WARN)
    return
  end

  local term = terminals[root]
  if term and (term.cmd ~= command or not job_running(term)) then
    term:shutdown()
    terminals[root] = nil
    term = nil
  end

  if not term then
    local Terminal = require("toggleterm.terminal").Terminal
    term = Terminal:new {
      cmd = command,
      dir = root,
      direction = "horizontal",
      size = 15,
      close_on_exit = true,
      spring_root = root,
      display_name = "Spring: " .. vim.fn.fnamemodify(root, ":t"),
      on_exit = function()
        terminals[root] = nil
      end,
    }
    terminals[root] = term
  end

  term:toggle(15, "horizontal")
end

local function stop()
  local root, term = current_spring_terminal()
  if not term then
    root = project_root()
    term = terminals[root]
  end
  if not term then
    vim.notify("No hay una aplicacion Spring ejecutandose en este proyecto", vim.log.levels.INFO)
    return
  end
  term:shutdown()
  terminals[root] = nil
end

return {
  {
    "JavaHello/spring-boot.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "akinsho/toggleterm.nvim",
    },
    opts = {
      autocmd = true,
      log_file = vim.fn.stdpath "state" .. "/spring-boot-ls.log",
    },
    config = function(_, opts)
      require("spring_boot").setup(opts)

      vim.api.nvim_create_user_command("SpringBootRun", function(info)
        run(info.args)
      end, { nargs = "*" })
      vim.api.nvim_create_user_command("SpringBootStop", stop, {})
    end,
    keys = {
      { "<leader>sr", run, desc = "Spring Boot: run" },
      { "<leader>sx", stop, desc = "Spring Boot: stop" },
    },
  },
}
