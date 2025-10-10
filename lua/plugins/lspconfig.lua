return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff_lsp = {
          init_options = {
            settings = {
              args = {},
            },
          },
        },
      },
      setup = {
        ruff_lsp = function(_, opts)
          local lspconfig = require("lspconfig")
          lspconfig.ruff_lsp.setup({
            on_attach = function(client, bufnr)
              -- Disable hover in favor of Pyright (if you use it later)
              client.server_capabilities.hoverProvider = false
              -- Autoformat and organize imports on save
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format({ async = false })
                end,
              })
            end,
            settings = opts.settings,
          })
        end,
      },
    },
  },
}
