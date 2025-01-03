-- ------------------------------------------------------------------------------------------------
-- let
-- ------------------------------------------------------------------------------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.g.netrw_liststyle = 3 -- how file explorer shows directory
-- disable for nvimtree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- ------------------------------------------------------------------------------------------------
-- set options 
-- ------------------------------------------------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 5
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true -- add indent when new line
vim.opt.wrap = false -- no wrap
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true -- if mixed case in searc will be case
vim.opt.termguicolors = true
vim.opt.signcolumn = "auto" -- clumn on the left to auto
vim.opt.formatoptions:remove { "c", "r", "o" }
vim.opt.backspace = "indent,eol,start"
vim.opt.splitright = true
vim.opt.splitbelow = true

-- ------------------------------------------------------------------------------------------------
-- lazy.nvim
-- ------------------------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

local lsp_servers = {
    lua_ls = {
        settings = {Lua = {completition = {callSnippet = "Replace"}}}
    },
    ruff = {},
    pylsp = {
        settings = {
            pylsp = {
                plugins = {
                    pyflakes = { enabled = false },
                    pycodestyle = { enabled = false },
                    autopep8 = { enabled = false },
                    yapf = { enabled = false },
                    mccabe = { enabled = false },
                    pylsp_mypy = { enabled = false },
                    pylsp_black = { enabled = false },
                    pylsp_isort = { enabled = false },
                },
            },
        },
    },
    zls = {},
    clangd = {}
}

local mason_tools = {
    "prettier", -- prettier formatter
    "stylua", -- lua formatter
    "isort", -- python formatter
    "clang-format" -- c++
}

require('lazy').setup({
    {
        -- -----------------------------------------------------------------------
        -- Plugin plenary
        -- -----------------------------------------------------------------------
        -- lua functions required by telescope
        'nvim-lua/plenary.nvim',
    },{
        -- -----------------------------------------------------------------------
        -- Plugin gruvbox-material
        -- -----------------------------------------------------------------------
        'sainnhe/gruvbox-material',
        lazy = false,
        priority = 1000,
        config = function()
            -- Optionally configure and load the colorscheme directly inside the plugin declaration.
            vim.g.gruvbox_material_enable_italic = true
            vim.cmd.colorscheme('gruvbox-material')
        end
    },{
        -- -----------------------------------------------------------------------
        -- Plugin vim-tmux-navigator
        -- -----------------------------------------------------------------------
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
            "TmuxNavigatorProcessList",
        },
        keys = {
            { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },{
        -- -----------------------------------------------------------------------
        -- Plugin nvim-tree
        -- -----------------------------------------------------------------------
        "nvim-tree/nvim-tree.lua",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("nvim-tree").setup({
                sort = { sorter = "case_sensitive", },
                view = { width = 30, },
                renderer = { group_empty = true, },
                filters = { dotfiles = false, custom = {".DS_Store"} },
                git = { ignore = false },
            })
        end
    },{ 
        -- -----------------------------------------------------------------------
        -- Plugin nvim-web-devicons
        -- -----------------------------------------------------------------------
        'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font 
    },{ 
        -- -----------------------------------------------------------------------
        -- Plugin which-key
        -- -----------------------------------------------------------------------
        'folke/which-key.nvim',
        event = "VeryLazy",
        opts = { delay = 0 },
        icons = { mappings = vim.g.have_nerd_font},
    },{
        -- -----------------------------------------------------------------------
        -- Plugin telescope
        -- -----------------------------------------------------------------------
        'nvim-telescope/telescope.nvim',
        event = "VeryLazy",
        branch = '0.1.x',
        dependencies = {   
            'nvim-lua/plenary.nvim',
            { 
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1 
                end,
            },
            { 
                'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font
            }
        },
        config = function()
            require('telescope').setup {
                defaults = {
                    path_display = { "smart" },
                },
                pickers = {
                    find_files = {
                        find_command = {'rg', '--files', '--hidden', '-g', '!.{git,DS_Store}'},
                    },
                },
                extensions = {
                    ['ui-select'] = { require('telescope.themes').get_dropdown(), }
                },
            }
            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')
            local builtin = require 'telescope.builtin'
            local map = vim.keymap.set -- for conciseness
            map('n', '<leader>fh', builtin.help_tags, { desc = '[f]ind [h]elp' })
            map('n', '<leader>fk', builtin.keymaps, { desc = '[f]ind [k]eymaps' })
            map('n', '<leader>ff', builtin.find_files, { desc = '[f]ind [f]iles' })
            map('n', '<leader>fs', builtin.builtin, { desc = '[f]ind [s]elect Telescope' })
            map('n', '<leader>fw', builtin.grep_string, { desc = '[f]ind [w]ord' })
            map('n', '<leader>fg', builtin.live_grep, { desc = '[f]ind by [g]rep' })
            map('n', '<leader>fd', builtin.diagnostics, { desc = '[f]ind [d]iagnostics' })
            map('n', '<leader>fr', builtin.resume, { desc = '[f]ind [r]esume' })
            map('n', '<leader>f.', builtin.oldfiles, { desc = '[f]ind recent files ("." for repeat)' })
            map('n', '<leader><leader>', builtin.buffers, { desc = '[ ] find existing buffers' })
            -- Slightly advanced example of overriding default behavior and theme
            map('n', '<leader>/', 
                function()
                    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
                    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                        winblend = 10,
                        previewer = false,
                    })
                end, 
                { desc = 'Fuzzily search in current buffer [/]'}
            )
            -- It's also possible to pass additional configuration options.
            --  See `:help telescope.builtin.live_grep()` for information about particular keys
            map('n', '<leader>f/', 
                function()
                    builtin.live_grep {
                        grep_open_files = true,
                        prompt_title = 'Live Grep in Open Files',
                    }
                end, { desc = 'search in open [f]iles [/]' }
            )
            -- Shortcut for searching your Neovim configuration files
            -- map('n', '<leader>fn', 
            --     function()
            --         builtin.find_files { cwd = vim.fn.stdpath 'config' }
            --     end, { desc = '[s]earch [n]eovim files' }
            -- )
        end,
    },{ 
        -- -----------------------------------------------------------------------
        -- Plugin telescope-ui
        -- -----------------------------------------------------------------------
        'nvim-telescope/telescope-ui-select.nvim' 
    },{
        -- -----------------------------------------------------------------------
        -- Plugin lualine
        -- -----------------------------------------------------------------------
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local lualine = require("lualine")
            lualine.setup({
                sections = {
                    lualine_c = {'buffers',},
                }
            })
            vim.opt.showtabline = 1
        end,
    },{
        -- -----------------------------------------------------------------------
        -- Plugin dressing
        -- -----------------------------------------------------------------------
        "stevearc/dressing.nvim",
        event = "VeryLazy",
    },{ 
        -- -----------------------------------------------------------------------
        -- Plugin nvim-treesitter
        -- -----------------------------------------------------------------------
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        main = 'nvim-treesitter.configs', -- Sets main module to use for opts
        opts = {
            ensure_installed = { 'python', 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
            -- Autoinstall languages that are not installed
            auto_install = true,
            highlight = {
                enable = true,
                -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                --  If you are experiencing weird indenting issues, add the language to
                --  the list of additional_vim_regex_highlighting and disabled languages for indent.
                -- additional_vim_regex_highlighting = { 'ruby' },
            },
            indent = { enable = true, disable = { 'ruby' } },
        },
        -- There are additional nvim-treesitter modules that you can use to interact
        -- with nvim-treesitter. You should go explore a few and see what interests you:
        --
        --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
        --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
        --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    },{
        -- -----------------------------------------------------------------------
        -- Plugin indent-blankline
        -- -----------------------------------------------------------------------
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPre", "BufNewFile" },
        main = "ibl",
        opts = { indent = { char = "┊" }, },
    },{
        -- -----------------------------------------------------------------------
        -- Plugin nvim-cmp
        -- -----------------------------------------------------------------------
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer", -- source for text in buffer
            "hrsh7th/cmp-path", -- source for file system paths
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*", -- follow latest release, replace <CurrentMajor> by the latest released major (first number of latest release)
                build = "make install_jsregexp", -- install jsregexp (optional!).
                dependencies = {
                    "rafamadriz/friendly-snippets", -- useful snippets
                    config = function()
                        require("luasnip.loaders.from_vscode").lazy_load() -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
                    end,
                }
            },
            "saadparwaiz1/cmp_luasnip", -- for autocompletion
            "onsails/lspkind.nvim", -- vs-code like pictograms
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            luasnip.config.setup()

            cmp.setup({
                completion = {
                    completeopt = "menu,menuone,preview,noselect",
                },
                snippet = { -- configure how nvim-cmp interacts with snippet engine
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                    ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
                    ["<C-e>"] = cmp.mapping.abort(), -- close completion window
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                }),
                -- sources for autocompletion
                sources = cmp.config.sources({
                    { name = "nvim_lsp"},
                    { name = "luasnip" }, -- snippets
                    { name = "buffer" }, -- text within current buffer
                    { name = "path" }, -- file system paths
                }),
                -- configure lspkind for vs-code like pictograms in completion menu
                formatting = {
                    format = lspkind.cmp_format({
                        maxwidth = 50,
                        ellipsis_char = "...",
                    }),
                },
            })
        end,
    },{
        -- -----------------------------------------------------------------------
        -- Plugin fidget
        -- -----------------------------------------------------------------------
        'j-hui/fidget.nvim', opts = {}
    },{
        -- -----------------------------------------------------------------------
        -- Plugin mason
        -- -----------------------------------------------------------------------
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
            local mason = require("mason")
            mason.setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
            local ensure_installed = vim.tbl_keys(lsp_servers or {})
            vim.list_extend(ensure_installed, mason_tools )
            local mason_tool_installer = require("mason-tool-installer")
            mason_tool_installer.setup({ ensure_installed = ensure_installed })
        end,
    },{
        -- -----------------------------------------------------------------------
        -- Plugin nvim-lspconfig
        -- -----------------------------------------------------------------------
        'neovim/nvim-lspconfig',
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp"
        },
        config = function()
             local keymap = vim.keymap.set

             vim.api.nvim_create_autocmd("LspAttach", {
                 group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                 callback = function(att_ev)
                     local map = function(keys, func, desc, mode)
                         mode = mode or 'n'
                         keymap(mode, keys, func, { buffer = att_ev.buf, desc = 'LSP: ' .. desc })
                     end
                     map('gd', require('telescope.builtin').lsp_definitions, '[g]oto [d]efinition')
                     map('gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration')
                     map('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
                     map('gI', require('telescope.builtin').lsp_implementations, '[g]oto [I]mplementation')
                     map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition') -- Jump to the implementation of the word under your cursor.
                     map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[d]ocument [s]ymbols') -- Fuzzy find all the symbols in your current document.
                     map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[w]orkspace [s]ymbols') -- Fuzzy find all the symbols in your current workspace.
                     map('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
                     map('<leader>ca', vim.lsp.buf.code_action, '[c]ode [a]ction', { 'n', 'x' })
                     -- The following two autocommands are used to highlight references of the
                     -- word under your cursor when your cursor rests there for a little while.
                     local client = vim.lsp.get_client_by_id(att_ev.data.client_id)
                     if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                         local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                         vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                             buffer = att_ev.buf,
                             group = highlight_augroup,
                             callback = vim.lsp.buf.document_highlight,
                         })

                         vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                             buffer = att_ev.buf,
                             group = highlight_augroup,
                             callback = vim.lsp.buf.clear_references,
                         })

                         vim.api.nvim_create_autocmd('LspDetach', {
                             group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                             callback = function(det_ev)
                                 vim.lsp.buf.clear_references()
                                 vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = det_ev.buf }
                             end,
                         })
                     end
                 end
             })
             local capabilities = vim.lsp.protocol.make_client_capabilities()
             capabilities = vim.tbl_deep_extend('force', capabilities,
             require('cmp_nvim_lsp').default_capabilities()
             )
             local mason_lspconfig = require("mason-lspconfig")
             mason_lspconfig.setup({
                 handlers = {
                     function(server_name)
                         local server = lsp_servers[server_name] or {}
                         -- This handles overriding only values explicitly passed
                         -- by the server configuration above. Useful when disabling
                         -- certain features of an LSP (for example, turning off formatting for ts_ls)
                         server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                         require('lspconfig')[server_name].setup(server)
                     end,
                 },
             })
         end
     },{
        -- -----------------------------------------------------------------------
        -- Plugin trouble
        -- -----------------------------------------------------------------------
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            focus = true,
        },
        cmd = "Trouble",
        keys = {
            { "<leader>tt", "<cmd>Trouble diagnostics toggle<CR>", desc = "[t]rouble [t]oggle" },
            { "<leader>td", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "[t]rouble [d]ocument diagnostics" },
            { "<leader>tq", "<cmd>Trouble quickfix toggle<CR>", desc = "[t]rouble [q]uickfix list" },
            { "<leader>tl", "<cmd>Trouble loclist toggle<CR>", desc = "[t]rouble [l]ocation list" },
        },
    },{
        -- -----------------------------------------------------------------------
        -- Plugin none-l
        -- -----------------------------------------------------------------------
        'nvimtools/none-ls.nvim',
        dependencies = {
            'nvimtools/none-ls-extras.nvim',
            'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
        },
        keys = {
            {
                "<leader>F",
                function() vim.lsp.buf.format { async = false } end,
                mode = { "v", "n" },
                desc = "[F]ormat buffer",
            },
        },
        config = function()
            local null_ls = require 'null-ls'
            local formatting = null_ls.builtins.formatting   -- to setup formatters
            local diagnostics = null_ls.builtins.diagnostics -- to setup linters

            -- list of formatters & linters for mason to install
            require('mason-null-ls').setup {
                ensure_installed = {
                    'checkmake',
                    'prettier', -- ts/js formatter
                    'stylua',   -- lua formatter
                    'shfmt',
                    'ruff',
                    'clang-format'
                },
                -- auto-install configured formatters & linters (with null-ls)
                automatic_installation = true,
            }

            local sources = {
                diagnostics.checkmake,
                formatting.prettier.with { filetypes = { 'html', 'json', 'yaml', 'markdown' } },
                formatting.stylua,
                formatting.shfmt.with { args = { '-i', '4' } },
                require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
                require 'none-ls.formatting.ruff_format',
            }

            local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
            null_ls.setup {
                -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
                sources = sources,
                -- you can reuse a shared lspconfig on_attach callback here
                on_attach = function(client, bufnr)
                    if client.supports_method 'textDocument/formatting' then
                        vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format { async = false }
                            end,
                        })
                    end
                end,
            }

        end,
    }
}) -- end Lazy setup

-- ------------------------------------------------------------------------------------------------
-- key bindings
-- ------------------------------------------------------------------------------------------------
local keymap = vim.keymap.set -- for conciseness

keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- window management
keymap("n", "<leader>wv", "<C-w>v", { desc = "Split [w]indow [v]ertically" }) -- split window vertically
keymap("n", "<leader>wh", "<C-w>h", { desc = "Split [w]indow [h]orizontally" }) -- split window horizontally
keymap("n", "<leader>we", "<C-w>=", { desc = "Make [w]indow [=]equal size" }) -- make split windows equal width & height
keymap("n", "<leader>wx", "<cmd>close<CR>", { desc = "[w]indow [x]Close" }) -- close current split window
-- tab management
keymap("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "[t]ab [o]pen new" }) -- open new tab
keymap("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "[t]ab [x]close current" }) -- close current tab
keymap("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "[t]ab go to [n]ext" }) --  go to next tab
keymap("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "[t]ab go to [p]revious" }) --  go to previous tab
keymap("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "[t]ab [f]open current buffer in new tab" }) --  move current buffer to new tab
-- nvim-tree
keymap("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "toggl[e] file [e]xplorer" }) -- toggle file explorer
keymap("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "toggle file [e]xplorer on current [f]ile" }) -- toggle file explorer on current file
keymap("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "file [e]xplorer [c]ollapse" }) -- collapse file explorer
keymap("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "file [e]xplorer [r]efresh" }) -- refresh file explorer
-- navigate buffers
keymap("n", "<tab>", "<cmd>bnext<CR>", { desc = "next buffer" })
keymap("n", "<S-l>", "<cmd>bnext<CR>", { desc = "next buffer" })
keymap("n", "<S-h>", "<cmd>bprev<CR>", { desc = "prev buffer" })
keymap("n", "<C-x>", "<cmd>bdelete<CR>", { desc = "close buffer" })
