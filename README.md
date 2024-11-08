# virt-column.nvim

Display a character as the colorcolumn.

<img width="900" src="https://user-images.githubusercontent.com/12900252/143544703-d94d6e9e-75f8-407d-976e-0fd5b341d751.png" alt="Screenshot" />

## Install

Use your favourite plugin manager to install.

For [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{ "lukas-reineke/virt-column.nvim" },
```

For [pckr.nvim](https://github.com/lewis6991/pckr.nvim):

```lua
use "lukas-reineke/virt-column.nvim"
```

## Setup

To configure virt-column.nvim you can run the setup function or put
configuration in `vim.g.virt_column` / `g:virt_column`. Running setup is not
necessary with the default configuration.

```lua
require("virt-column").setup({
    -- your config here
})
-- or:
vim.g.virt_column = {
    -- your config here
}
```

Please see [`:help virt-column.txt`](./doc/virt-column.txt) for more details
and all possible values.

## Thanks

Thank you @francium for the idea.
