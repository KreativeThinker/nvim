-- LSP servers: installed by mason, enabled automatically by mason-lspconfig (nvim-lspconfig supplies the configs)
local servers = {
	"lua_ls",
	"ansiblels",
	"docker_language_server",
	"biome",
}

return {
	{ "mason-org/mason.nvim", cmd = "Mason", keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } }, opts = {} },
	{
		"mason-org/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
						diagnostics = { globals = { "vim" } },
						telemetry = { enable = false },
					},
				},
			})
			-- TypeScript 7 native server (`tsc --lsp`). Only TS >= 7 has --lsp: use the project's tsc when it is 7+,
			-- else tsc from PATH if that is 7+ (mise: "npm:typescript" = "latest"). Otherwise don't start, and say why.
			local ts_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" }
			local path_ok -- cached: is `tsc` on PATH usable (>= 7)?
			local warned = false
			local function tsc_for(root)
				local pkg = root and vim.fs.joinpath(root, "node_modules/typescript/package.json")
				if pkg and vim.fn.filereadable(pkg) == 1 then
					local ok, json = pcall(vim.json.decode, table.concat(vim.fn.readfile(pkg), "\n"))
					local major = ok and tonumber((json.version or ""):match("^(%d+)"))
					local bin = vim.fs.joinpath(root, "node_modules/.bin/tsc")
					if major and major >= 7 and vim.fn.executable(bin) == 1 then
						return bin
					end
				end
				if path_ok == nil then
					local r = vim.fn.executable("tsc") == 1 and vim.system({ "tsc", "--version" }, { text = true }):wait(3000)
					local major = r and r.code == 0 and tonumber((r.stdout or ""):match("Version (%d+)"))
					path_ok = major ~= nil and major ~= false and major >= 7
				end
				return path_ok and "tsc" or nil
			end
			vim.lsp.config("tsc", {
				cmd = function(dispatchers, config)
					return vim.lsp.rpc.start({ tsc_for(config.root_dir) or "tsc", "--lsp", "--stdio" }, dispatchers)
				end,
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				root_dir = function(bufnr, on_dir)
					local root = vim.fs.root(bufnr, ts_markers)
					if tsc_for(root) then
						on_dir(root or vim.fn.getcwd())
					elseif not warned then
						warned = true
						vim.notify(
							"tsc LSP needs TypeScript >= 7: add typescript@7 to the project, or `mise use -g npm:typescript@latest`",
							vim.log.levels.WARN
						)
					end
				end,
			})
			vim.lsp.enable("tsc")

			require("mason-lspconfig").setup({ ensure_installed = servers, automatic_enable = servers })
		end,
	},
}
