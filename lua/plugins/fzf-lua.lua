return {
	"ibhagwan/fzf-lua",
	cmd = "FzfLua",
	config = function()
		require("fzf-lua").setup({})
		require("fzf-lua").register_ui_select() -- used by remote-nvim prompts
	end,
	keys = {
		{ "<leader><space>", "<cmd>FzfLua files<cr>", desc = "Files" },
		{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Files" },
		{ "<leader>fw", "<cmd>FzfLua live_grep<cr>", desc = "Grep" },
		{ "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
		{ "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
		{ "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "Help" },
		{ "<leader>fz", "<cmd>FzfLua blines<cr>", desc = "Buffer lines" },
		{ "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
		{ "<leader>fd", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Diagnostics" },
		{ "<leader>uc", "<cmd>FzfLua colorschemes<cr>", desc = "Themes" },
		{ "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Git status" },
		{ "gd", "<cmd>FzfLua lsp_definitions<cr>", desc = "Definitions" },
		{ "gr", "<cmd>FzfLua lsp_references<cr>", desc = "References" },
	},
}
