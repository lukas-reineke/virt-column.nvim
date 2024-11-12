# virt-column.nvim

Display a character as the colorcolumn.

<img width="900" src="https://user-images.githubusercontent.com/12900252/143544703-d94d6e9e-75f8-407d-976e-0fd5b341d751.png" alt="Screenshot" />

## Install

Use your favourite plugin manager to install.

For [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{ "lukas-reineke/virt-column.nvim", opts = {} },
```

For [pckr.nvim](https://github.com/lewis6991/pckr.nvim):

```lua
use "lukas-reineke/virt-column.nvim"
```

## Setup

To configure virt-column.nvim you need to run the setup function.

```lua
require("virt-column").setup()
```

Please see `:help virt-column.txt` for more details and all possible values.

## FAQ

#### I don't see anything

Ensure that colorcolumn is set.
```lua
vim.opt.colorcolumn="120"
```
#### I still see the regular color column behind virt-column

Ensure that ColorColumn highlight is properly cleared. If your colorscheme is setting it, you can use:
```lua
vim.cmd([[autocmd ColorScheme * highlight clear ColorColumn]])
```

## Thanks

Thank you @francium for the idea.
