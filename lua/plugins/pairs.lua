-- auto close brackets/quotes, and html/jsx tags
return {
	{ "nvim-mini/mini.pairs", event = "InsertEnter", opts = {} },
	{ "windwp/nvim-ts-autotag", event = "InsertEnter", opts = {} },
}
