-- floating terminals that survive hiding: processes keep running in the background.
--   <leader>th/tv/gg  toggle (hide if focused, focus if visible, else open/reattach)
--   <A-t>             toggle the last-used surface (works from terminal mode)
--   <C-h/j/k/l>       jump into a visible surface on that side (see config/keymaps.lua)
--   <leader>ts        list surfaces, pick one to reattach   :Run <cmd>  start a long task
--   inside a surface: <Esc><Esc> hide, <Esc><BS> kill, <Esc><arrows> move, <Esc>c center
local shell = os.getenv("SHELL") or "sh"

local function visible(t)
	return t and t.window and vim.api.nvim_win_is_valid(t.window)
end

local function show(cmd, pos)
	local S = require("surface")
	local t = S.terminals[cmd]
	if visible(t) then
		vim.api.nvim_set_current_win(t.window)
		vim.cmd.startinsert()
	else
		S.open(cmd, pos or (t and t.position) or "bottom")
	end
end

local function toggle(cmd, pos)
	local S = require("surface")
	local t = S.terminals[cmd]
	if visible(t) and vim.api.nvim_get_current_win() == t.window then
		S.hide(cmd)
	else
		show(cmd, pos)
	end
end

local last -- most recently opened surface command

-- hide the focused surface, else show the last-used one (default: shell at bottom)
local function toggle_last()
	local S = require("surface")
	for cmd, t in pairs(S.terminals) do
		if visible(t) and vim.api.nvim_get_current_win() == t.window then
			vim.cmd.stopinsert()
			return S.hide(cmd)
		end
	end
	show(last or shell, last and nil or "bottom")
end

local function pick()
	local S = require("surface")
	local cmds = vim.tbl_keys(S.terminals)
	table.sort(cmds)
	if #cmds == 0 then
		return vim.notify("No surfaces running")
	end
	vim.ui.select(cmds, {
		prompt = "Surfaces",
		format_item = function(c)
			return (visible(S.terminals[c]) and "● " or "○ ") .. c
		end,
	}, function(c)
		if c then
			show(c)
		end
	end)
end

return {
	"carldaws/surface.nvim",
	event = "VeryLazy",
	config = function()
		local S = require("surface")
		S.setup({ default_position = "center", mappings = {} })
		-- edge positions are real splits (content resizes); center stays a float
		local float_config = S.window_config_for
		local splits = {
			bottom = { split = "below", height = 0.35 },
			top = { split = "above", height = 0.35 },
			right = { split = "right", width = 0.4 },
			left = { split = "left", width = 0.4 },
		}
		S.window_config_for = function(t)
			local s = splits[t.position]
			if not s then
				return float_config(t)
			end
			return {
				split = s.split,
				win = -1,
				height = s.height and math.floor(vim.o.lines * s.height) or nil,
				width = s.width and math.floor(vim.o.columns * s.width) or nil,
			}
		end
		local open = S.open
		S.open = function(cmd, pos)
			last = cmd
			return open(cmd, pos)
		end

		local map = vim.keymap.set
		map("n", "<leader>th", function()
			toggle(shell, "bottom")
		end, { desc = "Terminal (bottom)" })
		map("n", "<leader>tv", function()
			toggle(shell, "right")
		end, { desc = "Terminal (right)" })
		map("n", "<leader>gg", function()
			toggle("lazygit", "center")
		end, { desc = "Lazygit" })
		map({ "n", "t" }, "<A-t>", toggle_last, { desc = "Toggle last surface" })

		vim.api.nvim_create_user_command("Run", function(a)
			show(a.args, "bottom")
		end, { nargs = "+", complete = "shellcmd" })
	end,
}
