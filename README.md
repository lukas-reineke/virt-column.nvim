# virt-column.nvim

Display a character as the colorcolumn.

<img width="900" src="https://user-images.githubusercontent.com/12900252/143544703-d94d6e9e-75f8-407d-976e-0fd5b341d751.png" alt="Screenshot" />

## Install

Use your favourite plugin manager to install.

#### Example with Packer

[wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
-- init.lua
require("packer").startup(
    function()
        use "lukas-reineke/virt-column.nvim"
    end
)
```

#### Example with Plug

[junegunn/vim-plug](https://github.com/junegunn/vim-plug)

```vim
" init.vim
call plug#begin('~/.vim/plugged')
Plug 'lukas-reineke/virt-column.nvim'
call plug#end()
```

## Setup

To configure virt-column.nvim you need to run the setup function.

```lua
require("virt-column").setup()
```

Please see `:help virt-column.txt`for more details and all possible values.

## Thanks

Thank you @francium for the idea.
