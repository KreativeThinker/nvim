-- main branch; needs the `tree-sitter` CLI to build parsers
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({
			"lua", "vim", "vimdoc", "bash", "python", "javascript", "typescript", "tsx",
			"json", "yaml", "toml", "markdown", "markdown_inline", "html", "css", "go", "rust",
		})
	end,
}
