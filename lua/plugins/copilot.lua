-- inline ghost-text suggestions (run `:Copilot auth` once)
return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		panel = { enabled = false },
		suggestion = {
			enabled = true,
			auto_trigger = true,
			debounce = 75,
			keymap = {
				accept = "<Right>",
				accept_word = "<C-Right>",
				accept_line = false,
				next = "<M-]>",
				prev = "<M-[>",
				dismiss = "<C-]>",
			},
		},
		filetypes = { markdown = true, yaml = true, help = false, gitcommit = false, gitrebase = false },
	},
}
