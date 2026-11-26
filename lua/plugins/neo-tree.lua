return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	cmd = "Neotree",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File tree" },
		{ "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal file" },
		{ "<leader>ge", "<cmd>Neotree git_status toggle<cr>", desc = "Git explorer" },
		{ "<leader>be", "<cmd>Neotree buffers toggle<cr>", desc = "Buffer explorer" },
	},
	init = function()
		-- `nvim <dir>` opens the tree
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("neotree_dir", { clear = true }),
			callback = function(ev)
				if vim.fn.isdirectory(ev.file) == 1 then
					require("neo-tree")
					vim.cmd("Neotree current dir=" .. vim.fn.fnameescape(ev.file))
					return true
				end
			end,
		})
	end,
	opts = {
		sources = { "filesystem", "buffers", "git_status" },
		open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" },
		close_if_last_window = true,
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = { enabled = true },
			window = { mappings = { ["H"] = "toggle_hidden" } },
			use_libuv_file_watcher = true,
			filtered_items = {
				visible = false, -- `H` toggles: show hidden + gitignored (dimmed)
				hide_dotfiles = true,
				hide_gitignored = true, -- honors .gitignore
				never_show = { ".git" },
			},
		},
		window = {
			width = 34,
			mappings = {
				["<space>"] = "none",
				["l"] = "open",
				["h"] = "close_node",
				["Y"] = {
					function(state)
						local p = state.tree:get_node():get_id()
						vim.fn.setreg("+", p, "c")
						vim.notify("Copied: " .. p)
					end,
					desc = "Copy path",
				},
				["P"] = { "toggle_preview", config = { use_float = false } },
			},
		},
		default_component_configs = {
			indent = { with_expanders = true, expander_collapsed = "", expander_expanded = "" },
			git_status = {
				symbols = {
					added = "", modified = "", deleted = "", renamed = "➜",
					untracked = "", ignored = "", unstaged = "", staged = "", conflict = "",
				},
			},
		},
	},
}
