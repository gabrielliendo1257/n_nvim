local M = {}

M.default = "one-dark-pro-max"

local function state_file()
  return vim.fn.stdpath("state") .. "/theme"
end

local function get_saved()
  local f = io.open(state_file(), "r")
  if not f then
    return nil
  end
  local name = f:read("*l")
  f:close()
  if name and name ~= "" then
    return name
  end
end

function M.apply(name)
  name = name or get_saved() or M.default
  local ok = pcall(vim.cmd.colorscheme, name)
  if not ok then
    vim.cmd.colorscheme(M.default)
  end
  M.apply_lsp_highlights()
end

local function mix(fg, bg, a)
  local function comp(f, b, t)
    return math.floor(f * t + b * (1 - t))
  end
  local r = comp(tonumber(fg:sub(2, 3), 16), tonumber(bg:sub(2, 3), 16), a)
  local g = comp(tonumber(fg:sub(4, 5), 16), tonumber(bg:sub(4, 5), 16), a)
  local b = comp(tonumber(fg:sub(6, 7), 16), tonumber(bg:sub(6, 7), 16), a)
  return string.format("#%02x%02x%02x", r, g, b)
end

function M.apply_lsp_highlights()
  local ok, palette = pcall(require, "one-dark-pro-max.palette")
  if not ok then
    return
  end
  local hl = vim.api.nvim_set_hl

  local severity_groups = {
    error = { "DiagnosticError", "DiagnosticSignError", "DiagnosticVirtualTextError" },
    warn = { "DiagnosticWarn", "DiagnosticSignWarn", "DiagnosticVirtualTextWarn" },
    hint = { "DiagnosticHint", "DiagnosticSignHint", "DiagnosticVirtualTextHint" },
  }
  local info = { "DiagnosticInfo", "DiagnosticSignInfo", "DiagnosticVirtualTextInfo" }
  for _, g in ipairs(info) do
    hl(0, g, { fg = palette.blue })
  end
  for name, groups in pairs(severity_groups) do
    for _, g in ipairs(groups) do
      hl(0, g, { fg = palette[name] })
    end
  end

  hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = palette.error })
  hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = palette.warn })
  hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = palette.blue })
  hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = palette.hint })
  hl(0, "DiagnosticVirtualTextError", { fg = palette.error, bg = mix(palette.error, palette.bg, 0.12) })
  hl(0, "DiagnosticVirtualTextWarn", { fg = palette.warn, bg = mix(palette.warn, palette.bg, 0.12) })
  hl(0, "DiagnosticVirtualTextInfo", { fg = palette.blue, bg = mix(palette.blue, palette.bg, 0.12) })
  hl(0, "DiagnosticVirtualTextHint", { fg = palette.hint, bg = mix(palette.hint, palette.bg, 0.12) })
  hl(0, "DiagnosticFloatingError", { fg = palette.error })
  hl(0, "DiagnosticFloatingWarn", { fg = palette.warn })
  hl(0, "DiagnosticFloatingInfo", { fg = palette.blue })
  hl(0, "DiagnosticFloatingHint", { fg = palette.hint })

  hl(0, "LspReferenceText", { bg = palette.visual })
  hl(0, "LspReferenceRead", { bg = palette.visual })
  hl(0, "LspReferenceWrite", { bg = palette.visual })
  hl(0, "LspSignatureActiveParameter", { fg = palette.keyword, bold = true })
  hl(0, "InlayHint", { fg = palette.hint, bg = mix(palette.hint, palette.bg, 0.1) })
  hl(0, "InlayHintSignature", { fg = palette.hint, bg = mix(palette.hint, palette.bg, 0.1) })

  local lsp_type_groups = {
    ["@lsp.type.comment"] = "@comment",
    ["@lsp.type.keyword"] = "@keyword",
    ["@lsp.type.function"] = "@function",
    ["@lsp.type.method"] = "@function",
    ["@lsp.type.function.macro"] = "@function",
    ["@lsp.type.function.method"] = "@function",
    ["@lsp.type.decorator"] = "@function",
    ["@lsp.type.property"] = "@property",
    ["@lsp.type.enumMember"] = "@property",
    ["@lsp.type.variable"] = "@variable",
    ["@lsp.type.variable.parameter"] = "@variable",
    ["@lsp.type.parameter"] = "@variable",
    ["@lsp.type.selfParameter"] = "@variable",
    ["@lsp.type.clsParameter"] = "@variable",
    ["@lsp.type.class"] = "@type",
    ["@lsp.type.interface"] = "@type",
    ["@lsp.type.struct"] = "@type",
    ["@lsp.type.enum"] = "@type",
    ["@lsp.type.typeAlias"] = "@type",
    ["@lsp.type.typeParameter"] = "@type",
    ["@lsp.type.string"] = "@string",
    ["@lsp.type.number"] = "@constant",
    ["@lsp.type.boolean"] = "@constant",
    ["@lsp.type.builtinConstant"] = "@constant",
    ["@lsp.type.constant"] = "@constant",
    ["@lsp.type.namespace"] = "@module",
    ["@lsp.type.modifier"] = "@keyword",
    ["@lsp.type.macro"] = "@keyword",
  }
  for target, source in pairs(lsp_type_groups) do
    hl(0, target, { link = source })
  end

  local kind_colors = {
    Text = palette.fg,
    Method = palette.func,
    Function = palette.func,
    Constructor = palette.func,
    Field = palette.property,
    Variable = palette.variable,
    Class = palette.type,
    Interface = palette.type,
    Module = palette.magenta,
    Property = palette.property,
    Unit = palette.fg,
    Value = palette.fg,
    Enum = palette.type,
    Keyword = palette.keyword,
    Snippet = palette.magenta,
    Color = palette.constant,
    File = palette.fg,
    Reference = palette.fg,
    Folder = palette.fg,
    EnumMember = palette.type,
    Constant = palette.constant,
    Struct = palette.type,
    Event = palette.yellow,
    Operator = palette.operator,
    TypeParameter = palette.type,
  }
  for kind, color in pairs(kind_colors) do
    hl(0, "BlinkCmpKind" .. kind, { fg = color })
  end
end

function M.select()
  local themes = vim.fn.getcompletion("", "color")
  vim.ui.select(themes, { prompt = "Theme:" }, function(choice)
    if not choice then
      return
    end
    M.apply(choice)
    local f = io.open(state_file(), "w")
    if f then
      f:write(choice)
      f:close()
    end
  end)
end

vim.api.nvim_create_user_command("Theme", M.select, {})

return M