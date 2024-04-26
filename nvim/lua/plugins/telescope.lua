return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<C-p>", builtin.find_files, {})
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
            vim.keymap.set("n", "<C-b>", builtin.buffers, {})
        end,
    },
    {
        -- we need this in order to have telescope creating a nice UI
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            local tconfig = require("telescope")
            tconfig.setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            tconfig.load_extension("ui-select")
        end,
    },
}
