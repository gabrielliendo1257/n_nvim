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