-- formatting on save; formatters come from mason
return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	cmd = "ConformInfo",
	keys = {
		{ "<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, mode = { "n", "x" }, desc = "Format" },
		{
			"<leader>uf",
			function()
				vim.g.autoformat = vim.g.autoformat == false
				vim.notify("Format on save: " .. (vim.g.autoformat == false and "off" or "on"))
			end,
			desc = "Toggle format on save",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "biome" },
			javascriptreact = { "biome" },
			typescript = { "biome" },
			typescriptreact = { "biome" },
			json = { "biome" },
			jsonc = { "biome" },
			css = { "biome" },
			yaml = { "yamlfmt" },
			["yaml.docker-compose"] = { "yamlfmt" },
			["yaml.ansible"] = { "yamlfmt" },
		},
		format_on_save = function()
			if vim.g.autoformat == false then
				return
			end
			return { timeout_ms = 2000, lsp_format = "fallback" }
		end,
	},
}
