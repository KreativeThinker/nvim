local map = vim.keymap.set

-- editing
map("i", "jk", "<Esc>")
map("t", "jk", [[<C-\><C-n>]])
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
map("n", "<Esc>", "<cmd>noh<cr>")
map("v", "<", "<gv")
map("v", ">", ">gv")
map("n", "<A-j>", "<cmd>m .+1<cr>==")
map("n", "<A-k>", "<cmd>m .-2<cr>==")
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { silent = true })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { silent = true })

-- comment toggle (built-in gc): line in normal mode (count works), selection in visual
map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment" })
map("x", "<leader>/", "gc", { remap = true, desc = "Toggle comment" })

-- copy the whole buffer to the system clipboard
map("n", "<C-c>", "<cmd>%y+<cr>", { desc = "Copy entire file" })

-- save / quit
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save" })
map("n", "<leader>ww", "<cmd>w<cr><esc>", { desc = "Save" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- buffers
map("n", "<tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-tab>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Alternate buffer" })
-- delete buffer but keep window layout (windows showing it switch to another buffer)
local function bufdelete(buf, close_win)
	buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
	if vim.bo[buf].modified then
		local c = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname(buf)), "&Yes\n&No\n&Cancel")
		if c == 0 or c == 3 then
			return
		end
		if c == 1 then
			vim.api.nvim_buf_call(buf, function()
				vim.cmd("write")
			end)
		end
	end
	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		if close_win and #vim.api.nvim_tabpage_list_wins(0) > 1 then
			vim.api.nvim_win_close(win, true)
		else
			vim.api.nvim_win_call(win, function()
				local alt = vim.fn.bufnr("#")
				if alt > 0 and alt ~= buf and vim.bo[alt].buflisted then
					vim.cmd("buffer #")
				else
					vim.cmd("silent! bnext")
				end
				if vim.api.nvim_win_get_buf(win) == buf then
					vim.cmd("enew")
				end
			end)
		end
	end
	if vim.api.nvim_buf_is_valid(buf) then
		pcall(vim.api.nvim_buf_delete, buf, { force = true })
	end
end

map("n", "<leader>bd", function()
	bufdelete()
end, { desc = "Delete buffer" })
map("n", "<leader>bD", function()
	bufdelete(nil, true)
end, { desc = "Delete buffer and window" })
map("n", "<leader>bo", function()
	local cur = vim.api.nvim_get_current_buf()
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		if b ~= cur and vim.bo[b].buflisted then
			bufdelete(b)
		end
	end
end, { desc = "Delete other buffers" })

-- windows
map("n", "<leader>wsh", "<C-w>s", { desc = "Split below" })
map("n", "<leader>wsv", "<C-w>v", { desc = "Split right" })
map("n", "<leader>wd", "<C-w>c", { desc = "Close window" })
map("n", "<leader>wm", "<C-w>|<C-w>_", { desc = "Maximize window" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize windows" })
map("n", "<C-Up>", "<cmd>resize +2<cr>")
map("n", "<C-Down>", "<cmd>resize -2<cr>")
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>")
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>")

-- tabs
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Prev tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close other tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First tab" })
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last tab" })

-- diagnostics
map("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>cq", "<cmd>copen<cr>", { desc = "Quickfix" })

-- C-h/j/k/l: jump into a visible surface lying in that direction, else nvim split / tmux pane.
-- From a terminal buffer, leave terminal mode first.
local edge = { Left = "left", Right = "right", Down = "bottom", Up = "top" }
local function into_surface(dir)
	local ok, S = pcall(require, "surface")
	if not ok then
		return false
	end
	local cur = vim.api.nvim_get_current_win()
	for _, t in pairs(S.terminals) do
		if t.position == edge[dir] and t.window and vim.api.nvim_win_is_valid(t.window) and t.window ~= cur then
			vim.api.nvim_set_current_win(t.window)
			vim.cmd.startinsert()
			return true
		end
	end
	return false
end

for key, dir in pairs({ h = "Left", j = "Down", k = "Up", l = "Right" }) do
	map("n", "<C-" .. key .. ">", function()
		if not into_surface(dir) then
			vim.cmd("TmuxNavigate" .. dir)
		end
	end, { desc = "Navigate " .. dir:lower() })
	map("t", "<C-" .. key .. ">", function()
		vim.cmd.stopinsert()
		vim.cmd("TmuxNavigate" .. dir)
	end, { desc = "Navigate " .. dir:lower() })
end
