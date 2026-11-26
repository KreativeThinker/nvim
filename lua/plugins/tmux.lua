-- C-h/j/k/l mappings live in config/keymaps.lua (they also reach surfaces)
return {
	"christoomey/vim-tmux-navigator",
	cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight" },
	init = function()
		vim.g.tmux_navigator_no_mappings = 1 -- else the plugin overrides ours when it lazy-loads
	end,
}
