return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		delay = 300,
		icons = { mappings = false },
		spec = {
			{ "<leader>a", group = "ai" },
			{ "<leader>b", group = "buffer" },
			{ "<leader>c", group = "code" },
			{ "<leader>f", group = "find" },
			{ "<leader>g", group = "git" },
			{ "<leader>gh", group = "hunks" },
			{ "<leader>m", group = "mise tasks" },
			{ "<leader>q", group = "quit" },
			{ "<leader>t", group = "terminal" },
			{ "<leader>u", group = "ui" },
			{ "<leader>w", group = "window" },
			{ "<leader>ws", group = "split" },
			{ "<leader><tab>", group = "tabs" },
		},
	},
	keys = {
		{ "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
	},
}
