-- buffer/tab bar; <Tab>/<S-Tab> cycle buffers
return {
	"akinsho/bufferline.nvim",
	version = "*",
	event = "VeryLazy",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {
		options = {
			mode = "buffers",
			diagnostics = "nvim_lsp",
			always_show_bufferline = true,
			separator_style = "thin",
			offsets = { { filetype = "neo-tree", text = "Files", text_align = "left", separator = true } },
		},
	},
	keys = {
		{ "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
		{ "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Close unpinned" },
		{ "<leader>bh", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer left" },
		{ "<leader>bl", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer right" },
		{ "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
	},
}
