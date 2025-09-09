---------------
-- Remapping --
---------------

-- Remap escape to jj in insert and visual mode.
vim.keymap.set({'i'}, 'jj', '<Esc>')

-------------------------
-- Basic Configuration --
-------------------------

-- Set the clipboard to use the system clipboard.
vim.opt.clipboard = 'unnamedplus'

-- Set tabexpand to true.
vim.opt.expandtab = true

-- Set the number of spaces to use for a tab.
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

----------------------------------
-- lazy.nvim package management --
----------------------------------

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set up the leader and local leader for lazy plugins.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load lazy.nvim
require("lazy").setup({
    -- color schemes
    'arcticicestudio/nord-vim',
    'morhetz/gruvbox',
    -- 'altercation/vim-colors-solarized',
    {
        "Tsuzat/NeoSolarized.nvim",
        priority = 1000,
        config = function()
        vim.o.termguicolors = true
        vim.o.background = "light"
        require("NeoSolarized").setup({
            style = "light",
            transparent = false,
            italic = false,
        })
        vim.cmd.colorscheme("NeoSolarized")
        end,
    },
    -- telescope
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    -- treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
          ensure_installed = { "c", "lua", "python", "rust", "solidity", "typescript" },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },
        })
      end
    },
    -- trouble
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" }
    },
    -- nerdtree
    'preservim/nerdtree',
    -- git
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = true
    },
    -- lsp
    'neovim/nvim-lspconfig',
    {
      "nvimtools/none-ls.nvim",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = { "williamboman/mason.nvim", "jay-babu/mason-null-ls.nvim" },
    },
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'nvim-lua/plenary.nvim',
}, {})

----------------
-- Appearance --
----------------

-- Set absolute line numbers.
vim.opt.number = true

-- -- Set the nord colorscheme
-- vim.cmd('colorscheme solarized')
-- vim.g.solarized_termcolors = 256

-- Set the background scheme.
vim.opt.background = 'light'

-- Discolor the 81 column
vim.opt.colorcolumn = '81'

---------------
-- telescope --
---------------

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-------------
-- trouble --
-------------

vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)

---------
-- Git --
---------

local neogit = require('neogit')
neogit.setup {}

---------
-- lsp --
---------

local lspconfig = require('lspconfig')
local cmp = require('cmp')

-- Function to dynamically get the uv-managed Python path
local function get_uv_python_path()
    local project_root = vim.fn.getcwd()  -- Assumes you open nvim from project root
    local uv_python = project_root .. "/.venv/bin/python"
    if vim.fn.executable(uv_python) == 1 then
        return uv_python
    end
    return vim.fn.exepath("python3") or "python"  -- Fallback to system Python
end

-- Set up Python LSP with uv environment
lspconfig.pylsp.setup {
    settings = {
        pylsp = {
            configurationSources = { "pyproject.toml" },  -- Use uv’s config if needed
            plugins = {
                jedi = {
                    environment = get_uv_python_path(),  -- Point to uv’s Python
                },
                pycodestyle = {
                    enabled = true,  -- Optional: Enable linting
                },
                pyflakes = {
                    enabled = true,  -- Optional: Enable error checking
                },
            },
        },
    },
}

-- Set up Typescript LSP
lspconfig.ts_ls.setup{}

-- Set up Zig LSP
lspconfig.zls.setup {}

-- Set up Rust LSP
lspconfig.rust_analyzer.setup {}

-- Set up Solidity LSP
lspconfig.solidity_ls.setup{}
-- FIXME
-- lspconfig.solidity.setup({
--   -- on_attach = on_attach, -- probably you will need this.
--   -- capabilities = capabilities,
--   settings = {
--     -- example of global remapping
--     solidity = {
--         includePath = '',
--         remapping = { ["@OpenZeppelin/"] = 'OpenZeppelin/openzeppelin-contracts@4.6.0/' },
--         -- Array of paths to pass as --allow-paths to solc
--         allowPaths = {}
--     }
--   },
-- })
-- lspconfig.solidity.setup {
--     cmd = { 'nomicfoundation-solidity-language-server', '--stdio' },
--     filetypes = { 'solidity' },
--     root_dir = require("lspconfig.util").find_git_ancestor,
--     single_file_support = true,
--     settings = {
--         solidity = {
--             hover = {
--                 enable = true,
--                 documentation = true,
--                 references = true,
--             },
--         },
--     },
--     handlers = {
--         ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
--     },
--     autostart = true,
-- }
-- vim.cmd([[
--   augroup SolidityAutoHover
--     autocmd!
--     autocmd CursorHold *.sol lua vim.lsp.buf.hover()
--   augroup END
-- ]])
-- vim.opt.updatetime = 300

-- ---- LSP / null-ls (none-ls) ----
local null_ls = require("null-ls")

-- define the augroup you reference below
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
  sources = {
    -- choose one formatter stack you actually use
    null_ls.builtins.formatting.prettier.with({
      filetypes = { "solidity", "typescript", "typescriptreact", "javascript", "javascriptreact", "json", "markdown" },
    }),
    -- or, if you prefer Biome instead of Prettier:
    -- null_ls.builtins.formatting.biome,
    -- null_ls.builtins.diagnostics.biome,

    -- extras
    null_ls.builtins.diagnostics.solhint,
    null_ls.builtins.formatting.rustfmt,
  },

  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})

-- Set up nvim-cmp
cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
})

-- Customize diagnostic signs and underlines
vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticUnderlineError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticUnderlineWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticUnderlineInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = ' ', texthl = 'DiagnosticUnderlineHint' })
vim.cmd [[
  highlight DiagnosticUnderlineError guisp=red gui=undercurl
  highlight DiagnosticUnderlineWarn guisp=yellow gui=undercurl
  highlight DiagnosticUnderlineInfo guisp=blue gui=undercurl
  highlight DiagnosticUnderlineHint guisp=green gui=undercurl
]]

-- Set up key mappings for LSP
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true })
vim.keymap.set(
    'n',
    ']d',
    '<cmd>lua vim.diagnostic.goto_next()<CR>',
    { noremap = true, silent = true }
)
vim.keymap.set(
    'n',
    ']D',
    '<cmd>lua vim.diagnostic.goto_prev()<CR>',
    { noremap = true, silent = true }
)

------------------
-- Autocommands --
------------------

-- Trim whitespace on save.
vim.cmd([[
  autocmd BufWritePre * %s/\s\+$//e
]])
