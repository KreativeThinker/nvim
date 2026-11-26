-- remote development over ssh
return {
	"amitds1997/remote-nvim.nvim",
	cmd = { "RemoteStart", "RemoteStop", "RemoteInfo", "RemoteCleanup", "RemoteConfigDel", "RemoteLog" },
	dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
	keys = { { "<leader>R", "<cmd>RemoteStart<cr>", desc = "Remote nvim (ssh)" } },
	config = true,
}
