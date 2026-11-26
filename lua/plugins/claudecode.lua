-- Claude Code in a native terminal split, IDE-style integration over websocket
return {
	"coder/claudecode.nvim",
	opts = { terminal = { provider = "native", split_width_percentage = 0.4 } },
	keys = {
		{ "<leader>a", nil, desc = "AI" },
		{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
		{ "<A-a>", "<cmd>ClaudeCode<cr>", mode = { "n", "t" }, desc = "Toggle Claude" },
		{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
		{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume" },
		{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue" },
		{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
		{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer" },
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
		{ "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", ft = { "neo-tree" }, desc = "Add file" },
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},
}
