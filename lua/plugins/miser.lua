-- mise integration for tool PATH and tasks only; LSP and formatting are handled by mason/conform
return {
	"carldaws/miser.nvim",
	config = function()
		require("miser").setup({
			auto_lsp = false,
			auto_format = false,
			task_runner = function(cmd)
				require("surface").open(cmd, "bottom") -- reattach later with <leader>ts
			end,
		})
	end,
}
