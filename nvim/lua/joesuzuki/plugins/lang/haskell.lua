-- import lspconfig plugin safely
local htconfig_status, htconfig = pcall(require, "haskell-tools")
if not htconfig_status then
  return
end

local def_opts = { noremap = true, silent = true }
local keymap = vim.keymap -- for conciseness
htconfig.start_or_attach({
  hls = {
    on_attach = function(client, bufnr)
      local opts = vim.tbl_extend("keep", def_opts, { buffer = bufnr })
      -- haskell-language-server relies heavily on codeLenses,
      -- so auto-refresh (see advanced configuration) is enabled by default
      keymap.set("n", "<space>ca", vim.lsp.codelens.run, opts)
      keymap.set("n", "<space>hs", htconfig.hoogle.hoogle_signature, opts)
      keymap.set("n", "<space>ea", htconfig.lsp.buf_eval_all, opts)
    end,
  },
})

-- Suggested keymaps that do not depend on haskell-language-server:
local bufnr = vim.api.nvim_get_current_buf()
-- set buffer = bufnr in ftplugin/haskell.lua
local opts = { noremap = true, silent = true, buffer = bufnr }

-- Toggle a GHCi repl for the current package
keymap.set("n", "<leader>rr", htconfig.repl.toggle, opts)
-- Toggle a GHCi repl for the current buffer
keymap.set("n", "<leader>rf", function()
  htconfig.repl.toggle(vim.api.nvim_buf_get_name(0))
end, def_opts)
keymap.set("n", "<leader>rq", htconfig.repl.quit, opts)

-- Detect nvim-dap launch configurations
-- (requires nvim-dap and haskell-debug-adapter)
htconfg.dap.discover_configurations(bufnr)
