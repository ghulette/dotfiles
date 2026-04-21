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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(ev)
    vim.keymap.set("n", "<leader>nn", toggle_check, { buffer = ev.buf, desc = "Toggle checkbox" })
  end,
})

return {}
