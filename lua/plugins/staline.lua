return {
  {
    "tamton-aquib/staline.nvim",
    event = "VeryLazy",
    opts = {
      defaults = {
        true_colors = true,
        fg = "#986fec",
        left_separator = "",
        right_separator = "",
        line_column = "[%l:%c] 並%p%% ",
      },
      mode_colors = {
        n = "#181a23",
        i = "#181a23",
        ic = "#181a23",
        c = "#181a23",
        v = "#181a23",
        R = "#181a23",
        t = "#181a23",
      },
      lsp_symbols = {
        Error = "  ",
        Info = "  ",
        Warn = "  ",
        Hint = " 󰛨 ",
      },
    },
    config = function(_, opts)
      local rs = opts.defaults.right_separator
      local ls = opts.defaults.left_separator

      local function pill(inner)
        if inner == "" then
          return ""
        end
        return "%#MidSep#" .. rs .. "%#DoubleSep#" .. rs
          .. "%#StalineFill# " .. inner .. " "
          .. "%#DoubleSep#" .. ls .. "%#MidSep#" .. ls
      end

      local os_icon = vim.g.staline_os_icon
      if not os_icon then
        local icons = {
          arch = "", ubuntu = "", debian = "", fedora = "",
          manjaro = "", nixos = "", darwin = "󰀵", windows = "󰪥",
        }
        local id
        local sys = vim.loop.os_uname().sysname
        if sys == "Darwin" then
          id = "darwin"
        elseif sys == "Windows_NT" then
          id = "windows"
        else
          local f = io.open("/etc/os-release")
          if f then
            for line in f:lines() do
              local v = line:match("^ID=(.+)$")
              if v then
                id = v:lower():gsub('"', "")
                break
              end
            end
            f:close()
          end
        end
        os_icon = icons[id] or ""
        vim.g.staline_os_icon = os_icon
      end

      local function cwd_section()
        return pill(vim.fn.fnamemodify(vim.fn.getcwd(), ":t"))
      end

      local function branch_section()
        return pill(vim.b.staline_branch or "")
      end

      local function venv_section()
        local venv = vim.env.VIRTUAL_ENV
        if not venv or venv == "" then
          return ""
        end
        return pill("󰌠 " .. vim.fn.fnamemodify(venv, ":t"))
      end

      local function lsp_section()
        local parts = {}
        local symbols = { Error = "  ", Warn = "  ", Info = "  ", Hint = " 󰛨 " }
        for sev, sym in pairs(symbols) do
          local n = #vim.diagnostic.get(0, { severity = sev })
          if n > 0 then
            parts[#parts + 1] = "%#DiagnosticSign" .. sev .. "#" .. sym .. n
          end
        end
        local clients = {}
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
          clients[#clients + 1] = client.name
        end
        if #clients > 0 then
          parts[#parts + 1] = table.concat(clients, ", ")
        end
        return pill(table.concat(parts, " "))
      end

      local function os_section()
        return pill(os_icon)
      end

      opts.sections = {
        left = {
          " ", "right_sep_double", "-mode", "left_sep_double",
          cwd_section, branch_section,
        },
        mid = { lsp_section },
        right = {
          venv_section,
          "right_sep_double", "-file_name", "left_sep_double",
          os_section,
          "right_sep_double", "-line_column", "left_sep_double",
        },
      }

      require("staline").setup(opts)
    end,
  },
}