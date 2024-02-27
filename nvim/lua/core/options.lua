-- Core configuration options

local options = {    

    --- Auto-indenting options
    breakindent = true,                         -- Enable automatic indentation of wrapped lines
    shiftwidth = 4,                             -- Set the number of spaces for each indentation level
    smartindent = true,                         -- Enable smart indentation based on context

    -- Column options
    colorcolumn = "120",                        -- Highlight a color column
    signcolumn = "yes",                         -- Show signs (e.g., line markers for breakpoints) in the sign column

    -- Completeopt options
    completeopt = { "menuone", "noselect"},     -- Enable completion menu, single match and no auto-select

    -- Clipboard options
    clipboard = "unnamed,unnamedplus",          -- Use system clipboard and clipboard for yank, delete, and put

    -- Cursor options
    cursorline = true,                          -- Highlight the current line
    guicursor = "",

    -- Fold options
    foldcolumn = "0",                           -- Disable the fold column
    foldenable = true,                          -- Enable code folding
    foldlevel = 99,                             -- Set maximum fold level
    foldlevelstart = 99,                        -- Start with all folds open

    -- Line numbers options
    number = true,                              -- Show absolute line numbers
    relativenumber = true,                      -- Show relative numbers

    -- Mouse mode options
    mouse = "a",                                -- Enable mouse support in all modes

    -- Scroll options
    scrolloff = 8,                              -- Minimum number of lines to keep above/below the cursor

    -- Search options
    hlsearch = false,                            -- Highlight search matches
    ignorecase = true,                          -- Ignore case in search patterns
    incsearch = true,                           -- Perform incremental search for faster navigation
    smartcase = true,                           -- Use case-sensitive search if any capital letters are used

    -- Split options
    splitbelow = true,                          -- Open new split windows below the current window
    splitright = true,                          -- Open new split windows to the right of the current window

    -- Tab spaces options
    expandtab = true,                           -- Use spaces isntead of tabs for indentation
    softtabstop = 4,                            -- Set the number of spaces for tab characters
    tabstop = 4,                                -- Set the width of tab characters

    -- Terminal color options
    termguicolors = true,                       -- Use true colors in the terminal

    -- Text wrapping options
    wrap = false,                               -- Disable text wrapping to maintain code readability

    -- Undo options
    undofile = true,                            -- Enable persistent undo across sessions
}

-- Apply the configure options to the editor
for key, value in pairs(options) do
    vim.opt[key] = value
end
