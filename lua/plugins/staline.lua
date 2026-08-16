return {
  {
    "tamton-aquib/staline.nvim",
    event = "VeryLazy",
    opts = {
      defaults = {
        true_colors = true,
        font_active = "bold",
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

      local function git_diff_section()
        return pill(vim.b.gitsigns_status or "")
      end

      local function size_section()
        local name = vim.api.nvim_buf_get_name(0)
        if name == "" then
          return ""
        end
        local size = vim.fn.getfsize(name)
        if size < 0 then
          return ""
        end
        local unit = "B"
        if size >= 1024 * 1024 then
          size, unit = size / 1024 / 1024, "M"
        elseif size >= 1024 then
          size, unit = size / 1024, "K"
        end
        return pill(("%.1f"):format(size) .. unit)
      end

      local function type_section()
        local ft = vim.bo.filetype
        if ft == "" then
          return ""
        end
        local enc = vim.bo.fileencoding
        if enc == "" then
          enc = vim.o.encoding
        end
        if enc ~= "utf-8" then
          ft = ft .. " " .. enc
        end
        return pill(ft)
      end

      local function time_section()
        return pill("%{strftime('%H:%M')}")
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
          cwd_section, branch_section, git_diff_section,
        },
        mid = { lsp_section },
        right = {
          venv_section,
          "right_sep_double", "-file_name", "left_sep_double",
          size_section, type_section,
          os_section, time_section,
          "right_sep_double", "-line_column", "left_sep_double",
        },
      }

      require("staline").setup(opts)
    end,
  },
}