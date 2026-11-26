return {
	"saghen/blink.cmp",
	version = "1.*", -- prebuilt fuzzy binary
	event = "InsertEnter",
	opts = {
		-- Enter confirms; Tab / S-Tab move through the menu (Tab also jumps snippet fields)
		keymap = {
			preset = "enter",
			["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
		},
		sources = { default = { "lsp", "path", "buffer" } },
		completion = {
			list = { selection = { preselect = false, auto_insert = false } }, -- Tab picks; Enter only confirms a picked item
			documentation = { auto_show = true },
			ghost_text = { enabled = false }, -- supermaven owns ghost text
		},
	},
	config = function(_, opts)
		require("blink.cmp").setup(opts)
		vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
	end,
}
