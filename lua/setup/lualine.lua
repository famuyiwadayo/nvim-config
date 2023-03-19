local function getWords()
  if vim.bo.filetype == "md" or vim.bo.filetype == "txt" or vim.bo.filetype == "markdown" then
    if vim.fn.wordcount().visual_words == 1 then
      return tostring(vim.fn.wordcount().visual_words) .. " word"
    elseif not (vim.fn.wordcount().visual_words == nil) then
      return tostring(vim.fn.wordcount().visual_words) .. " words"
    else
      return tostring(vim.fn.wordcount().words) .. " words"
    end
  else
    return ""
  end
end

local function place()
  local colPre = "C:"
  local col = "%c"
  local linePre = " L:"
  local line = "%l/%L"
  return string.format("%s%s%s%s", colPre, col, linePre, line)
end

--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.fn.winwidth(0)
    if hide_width and win_width < hide_width then
      return ""
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
      return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
    end
    return str
  end
end

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local function window()
  return vim.api.nvim_win_get_number(0)
end
-- get colors from Nightfox to use in the words count
-- local nfColors = require("nightfox.colors").init("nordfox")

-- print(vim.inspect(nfColors))
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { " ", " " },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {},
  },
  sections = {
    lualine_a = {
      { "mode", fmt = trunc(80, 1, nil, true) },
    },
    lualine_b = {
      { "branch", icon = "" },
      {
        "diff",
        source = diff_source,
        color_added = "#a7c080",
        color_modified = "#ffdf1b",
        color_removed = "#ff6666",
      },
    },
    lualine_c = {
      { "diagnostics", sources = { "nvim_diagnostic" } },
      function()
        return "%="
      end,
      {
        "filename",
        path = 0,
        shorting_target = 40,
        symbols = {
          modified = "落", -- Text to show when the file is modified.
          readonly = "", -- Text to show when the file is non-modifiable or readonly.
          unnamed = "[No Name]", -- Text to show for unnamed buffers.
          newfile = "[New]", -- Text to show for new created file before first writting
        },
      },
      {
        getWords,
        color = { fg = "#333333", bg = "#eeeeee" },
        separator = { left = "", right = "" },
      },
      {
        "searchcount",
      },
    },
    lualine_x = { { "filetype", icon_only = true } },
    lualine_y = { { require("auto-session-library").current_session_name } },
    lualine_z = {
      { place, padding = { left = 1, right = 1 } },
    },
  },
  inactive_sections = {
    lualine_a = { window },
    lualine_b = {
      {
        "diff",
        source = diff_source,
        color_added = "#a7c080",
        color_modified = "#ffdf1b",
        color_removed = "#ff6666",
      },
    },
    lualine_c = {
      function()
        return "%="
      end,
      {
        "filename",
        path = 1,
        shorting_target = 40,
        symbols = {
          modified = "落", -- Text to show when the file is modified.
          readonly = "", -- Text to show when the file is non-modifiable or readonly.
          unnamed = "[No Name]", -- Text to show for unnamed buffers.
          newfile = "[New]", -- Text to show for new created file before first writting
        },
      },
    },
    lualine_x = {
      { place, padding = { left = 1, right = 1 } },
    },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {
    "quickfix",
  },
})



-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

-- stylua: ignore
-- local colors = {
--   blue   = '#80a0ff',
--   cyan   = '#79dac8',
--   black  = '#080808',
--   white  = '#c6c6c6',
--   red    = '#ff5189',
--   violet = '#d183e8',
--   grey   = '#303030',
-- }

-- local bubbles_theme = {
--   normal = {
--     a = { fg = colors.black, bg = colors.violet },
--     b = { fg = colors.white, bg = colors.grey },
--     c = { fg = colors.black, bg = colors.black },
--   },

--   insert = { a = { fg = colors.black, bg = colors.blue } },
--   visual = { a = { fg = colors.black, bg = colors.cyan } },
--   replace = { a = { fg = colors.black, bg = colors.red } },

--   inactive = {
--     a = { fg = colors.white, bg = colors.black },
--     b = { fg = colors.white, bg = colors.black },
--     c = { fg = colors.black, bg = colors.black },
--   },
-- }

-- require('lualine').setup {
--   options = {
--     theme = bubbles_theme,
--     component_separators = '|',
--     section_separators = { left = '', right = '' },
--   },
--   sections = {
--     lualine_a = {
--       { 'mode', separator = { left = '' }, right_padding = 2 },
--     },
--     lualine_b = { 'filename', 'branch' },
--     lualine_c = { 'fileformat' },
--     lualine_x = {},
--     lualine_y = { 'filetype', 'progress' },
--     lualine_z = {
--       { 'location', separator = { right = '' }, left_padding = 2 },
--     },
--   },
--   inactive_sections = {
--     lualine_a = { 'filename' },
--     lualine_b = {},
--     lualine_c = {},
--     lualine_x = {},
--     lualine_y = {},
--     lualine_z = { 'location' },
--   },
--   tabline = {},
--   extensions = {},
-- }