-- LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local o = { buffer = ev.buf }
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", o, { desc = "Rename" }))
		vim.keymap.set(
			{ "n", "x" },
			"<leader>ca",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", o, { desc = "Code action" })
		)
	end,
})

-- treesitter highlight/indent
vim.api.nvim_create_autocmd("FileType", {
	callback = function(ev)
		if pcall(vim.treesitter.start, ev.buf) then
			vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

-- reload files changed outside nvim (lazygit, LLM agents)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermClose", "TermLeave" }, {
	command = "silent! checktime",
})

-- compose/ansible files get their own filetypes so the right LSP attaches
vim.filetype.add({
	filename = {
		["compose.yaml"] = "yaml.docker-compose",
		["compose.yml"] = "yaml.docker-compose",
		["site.yml"] = "yaml.ansible",
		["site.yaml"] = "yaml.ansible",
		["playbook.yml"] = "yaml.ansible",
		["playbook.yaml"] = "yaml.ansible",
		["docker-compose.yaml"] = "yaml.docker-compose",
		["docker-compose.yml"] = "yaml.docker-compose",
	},
	pattern = {
		[".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
		[".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
		[".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",
		["docker%-compose%..*%.ya?ml"] = "yaml.docker-compose",
		["compose%..*%.ya?ml"] = "yaml.docker-compose",
	},
})
