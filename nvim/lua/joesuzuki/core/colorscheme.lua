local status, _ = pcall(vim.cmd, "colorscheme eva01")
if not status then
  print("Colorscheme not found!")
  return
end
