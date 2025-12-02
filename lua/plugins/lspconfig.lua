return {
  {
    "neovim/nvim-lspconfig",
    ft = { "python", "cpp", "lua" }, -- ensures lsp registration happens when these filetypes open
    opts = function(_, opts)
      -- Load language configs
      local python = require("languages.python")
      local cpp = require("languages.cpp")
      local lua_lang = require("languages.lua")

      -- Merge servers from all languages
      opts.servers = vim.tbl_deep_extend(
        "force",
        opts.servers or {},
        python.lsp or {},
        cpp.lsp or {},
        lua_lang.lsp or {}
      )

      -- Merge custom setup functions
      opts.setup = opts.setup or {}

      if python.lsp_setup then
        for server, setup_fn in pairs(python.lsp_setup) do
          opts.setup[server] = setup_fn
        end
      end

      if cpp.lsp_setup then
        for server, setup_fn in pairs(cpp.lsp_setup) do
          opts.setup[server] = setup_fn
        end
      end

      if lua_lang.lsp_setup then
        for server, setup_fn in pairs(lua_lang.lsp_setup) do
          opts.setup[server] = setup_fn
        end
      end

      return opts
    end,
  },
}

