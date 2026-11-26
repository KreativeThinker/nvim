-- formatters/linters installed by mason (LSP servers live in lsp.lua)
return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	event = "VeryLazy",
	dependencies = "mason-org/mason.nvim",
	opts = {
		ensure_installed = { "stylua", "yamlfmt", "hadolint", "ansible-lint" },
	},
}
