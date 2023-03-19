-- This file can be loaded by calling `lua require('plugins')` from your init.vim
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

require("mappings")

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

vim.cmd("set number")

-- returns the require for use in `config` parameter of packer's use
-- expects the name of the config file
function get_setup(name)
  return string.format('require("setup/%s")', name)
end

-- require("setup.lualine")

return require('packer').startup({
  function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use({ "kyazdani42/nvim-web-devicons" })
    use({ "stevearc/dressing.nvim" })
    use({ "nvim-lua/plenary.nvim" })

    use({ "lukas-reineke/indent-blankline.nvim", config = get_setup("indent-blankline") })
    use({ "rebelot/kanagawa.nvim", config = get_setup("kanagawa"), priority = 1000, lazy = false })
    use({ "mbbill/undotree" })

     use({
      "lewis6991/gitsigns.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      event = "BufReadPre",
      config = get_setup("gitsigns"),
    })

    use({
        "nvim-lualine/lualine.nvim",
        as = "lualine",
        config = get_setup("lualine"),
        event = "VimEnter",
        requires = { "kyazdani42/nvim-web-devicons" },
    })
    use({ "lukas-reineke/headlines.nvim", config = get_setup("headlines") })

    use({
        "gen740/SmoothCursor.nvim",
        config = get_setup("smoothcursor"),
    })
    use({ "brenoprata10/nvim-highlight-colors", config = get_setup("highlight-colors") })

    use({
      'rmagatti/auto-session',
      config = function()
        require("auto-session").setup {
          log_level = "error",
          auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
        }
      end
    })

    use({
      "rmagatti/session-lens",
      requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
      config = get_setup("session"),
    })

    use({
      "hrsh7th/nvim-cmp",
      requires = {
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/vim-vsnip" },
        { "hrsh7th/cmp-vsnip" },
        { "hrsh7th/vim-vsnip-integ" },
        { "hrsh7th/cmp-calc" },
        { "rafamadriz/friendly-snippets" },
      },
      config = get_setup("cmp"),
    })

    use({
      "nvim-treesitter/nvim-treesitter",
      config = get_setup("treesitter"),
      run = ":TSUpdate",
    })
    use({ "nvim-treesitter/nvim-treesitter-textobjects" })
    use({ "rcarriga/nvim-notify" })

    use({
        "windwp/nvim-autopairs",
        after = "nvim-cmp",
        config = get_setup("autopairs"),
    })
    use({ "goolord/alpha-nvim", config = get_setup("alpha") })

    use({ 'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons', config = get_setup("bufferline") })


    use({ "neovim/nvim-lspconfig", config = get_setup("lsp") })
    use({
      "nvim-telescope/telescope.nvim",
      module = "telescope",
      cmd = "Telescope",
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      },
      config = get_setup("telescope"),
    })
    use({ "nvim-telescope/telescope-file-browser.nvim" })
    use({ "famiu/bufdelete.nvim" })
    -- use({
    --   "kylechui/nvim-surround",
    --   config = function()
    --     require("nvim-surround").setup({})
    --   end,
    -- })

    use({
      "numToStr/Comment.nvim",
      config = get_setup("comment"),
    })

    use({"sidebar-nvim/sidebar.nvim", as = "sidebar", config = get_setup("sidebar") })

    
    -- You can alias plugin names
    -- use {'dracula/vim', as = 'dracula'}
    use {'neoclide/coc.nvim', branch = 'release'}
    -- use {"EdenEast/nightfox.nvim", as = 'nightfox'}

    use({
      "folke/which-key.nvim", 
      config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
        get_setup("which-key")
      end 
    })

    if packer_bootstrap then
      require("packer").sync()
    end
  end,

  config = {
    display = {
      open_fn = require("packer.util").float,
    },
    profile = {
      enable = true,
      threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
    },
  },

})

