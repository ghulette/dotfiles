-- Checkbox toggle for markdown, no treesitter dependency.
local function toggle_check()
  local line = vim.api.nvim_get_current_line()
  local new
  if line:match("%- %[ %]") then
    new = line:gsub("%- %[ %]", "- [x]", 1)
  elseif line:match("%- %[x%]") then
    new = line:gsub("%- %[x%]", "- [ ]", 1)
  elseif line:match("^%s*%- ") then
    new = line:gsub("^(%s*%- )", "%1[ ] ", 1)
  elseif line:match("^%s*$") then
    new = "- [ ] "
  else
    return
  end
  vim.api.nvim_set_current_line(new)
  -- On a fresh empty checkbox, drop into insert mode at end of line.
  if line:match("^%s*$") then
    vim.cmd("startinsert!")
  end
end

local function insert_at_text()
  local line = vim.api.nvim_get_current_line()
  local _, stop = line:find("^%s*[-*+]%s+%[[ xX]%]%s+")
  if not stop then _, stop = line:find("^%s*[-*+]%s+") end
  if not stop then _, stop = line:find("^%s*%d+[.)]%s+") end
  if stop then
    vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), stop })
  end
  vim.cmd("startinsert")
end

local function smart_cr()
  local line = vim.api.nvim_get_current_line()
  -- Match list prefixes: bullet with optional checkbox, or numbered.
  local indent, marker, num = line:match("^(%s*)([-*+])%s+%[[ xX]%]%s*(.-)$")
  if marker then
    marker = marker .. " [ ]"
  else
    indent, marker, num = line:match("^(%s*)([-*+])%s+(.-)$")
    if not marker then
      local rest
      indent, num, marker, rest = line:match("^(%s*)(%d+)([.)])%s+(.-)$")
      if marker then
        local next_num = tonumber(num) + 1
        marker = tostring(next_num) .. marker
        num = rest
      end
    end
  end
  if not marker then
    return "\n"
  end
  -- Empty bullet: clear the line and stay in insert.
  if num == "" or num == nil then
    vim.api.nvim_set_current_line("")
    return ""
  end
  return "\n" .. indent .. marker .. " "
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(ev)
    vim.keymap.set("n", "<leader>nn", toggle_check, { buffer = ev.buf, desc = "Toggle checkbox" })
    vim.keymap.set("n", "<leader>ni", insert_at_text, { buffer = ev.buf, desc = "Insert at bullet text" })
    vim.keymap.set("i", "<CR>", smart_cr, { buffer = ev.buf, expr = true, desc = "Continue list on Enter" })
  end,
})

return {}
