-- splash screen
return {
	"nvim-mini/mini.starter",
	event = "VimEnter",
	config = function()
		local starter = require("mini.starter")
		starter.setup({
			header = table.concat({
				"███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
				"████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
				"██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
				"██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
				"██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
				"╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
			}, "\n"),
			items = {
				{ name = "Find file", action = "FzfLua files", section = "Actions" },
				{ name = "Grep", action = "FzfLua live_grep", section = "Actions" },
				{ name = "Recent", action = "FzfLua oldfiles", section = "Actions" },
				{ name = "File tree", action = "Neotree toggle", section = "Actions" },
				{ name = "Claude", action = "ClaudeCode", section = "Actions" },
				{ name = "Lazygit", action = "lua require('surface').open('lazygit', 'center')", section = "Actions" },
				{ name = "New file", action = "enew", section = "Actions" },
				{ name = "Plugins", action = "Lazy", section = "Actions" },
				{ name = "Quit", action = "qa", section = "Actions" },
				starter.sections.recent_files(5, true, false),
			},
			content_hooks = {
				starter.gen_hook.adding_bullet(),
				starter.gen_hook.aligning("center", "center"),
			},
			footer = "",
		})
	end,
}
