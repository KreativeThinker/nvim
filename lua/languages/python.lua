-- languages/python.lua
local M = {}

M.servers = { "ty", "ruff", "pyright" }

M.setup = {
  ty = function()
    local lspconfig = require("lspconfig")
    local configs = require("lspconfig.configs")

    -- register server if not already defined
    if not configs.ty then
      configs.ty = {
        default_config = {
          cmd = { "ty", "lsp" },
          filetypes = { "python" },
        },
      }
    end

    vim.lsp.config("ty", {
      settings = {
        ty = {
          experimental = {
            rename = true,
            autoImport = true,
          },
        },
      },
    })
  end,

  ruff = function()
    vim.lsp.config("ruff", {
      on_attach = function(client)
        client.server_capabilities.hoverProvider = false
        client.server_capabilities.completionProvider = nil
      end,
    })
  end,

  pyright = function()
    vim.lsp.config("pyright", {
      settings = {
        pyright = {
          disableLanguageServices = true,
          disableOrganizeImports = true,
        },
        python = {
          analysis = {
            autoImportCompletions = true,
            typeCheckingMode = "off",
          },
        },
      },
      on_attach = function(client)
        client.server_capabilities.hoverProvider = false
        client.server_capabilities.diagnosticProvider = false
      end,
    })
  end,
}

M.formatters = {
  python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
}

M.dap_setup = function()
  local ok, dap = pcall(require, "dap")
  if not ok then
    return
  end

  dap.adapters.python = {
    type = "executable",
    command = "python",
    args = { "-m", "debugpy.adapter" },
  }

  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      name = "Launch File",
      program = "${file}",
      console = "integratedTerminal",
    },
    {
      type = "python",
      request = "launch",
      name = "Launch App",
      program = "${workspaceFolder}/main.py",
      console = "integratedTerminal",
    },
  }
end

return M
