-- colorschemes; pick with <leader>th (live preview), choice persists across restarts
local state = vim.fn.stdpath("data") .. "/colorscheme"

local function persist()
	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = function(ev)
			pcall(vim.fn.writefile, { ev.match }, state)
		end,
	})
	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyDone",
		once = true,
		callback = function()
			local ok, lines = pcall(vim.fn.readfile, state)
			vim.cmd.colorscheme((ok and lines[1] ~= "" and lines[1]) or "tokyonight")
		end,
	})
end

return {
	{ "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },
	{ "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000, opts = {} },
	{ "Mofiqul/dracula.nvim", lazy = false, priority = 1000, opts = {}, init = persist },
}
