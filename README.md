# nvim_config

- Default setup :
    - Windows 10
    -

## Installation sequence

### For Windows
1. mason.nvim
    1) pwsh
    2) git
    3) GNU tar
    4) 7zip
2. unzip
3. wget
4. curl
5. gzip
6. tar
7. bash
8. sh


### For Ubuntu 22.04

1. mason.nvim
    1) git : default
    2) curl : default
    3) wget : default
    4) unzip : default
    5) tar or gtar : default
    6) gzip : default
    7) python3 : `sudo apt-get install -y python3` (it may be installed 3.10.6 version by default)
    8) pip/pip3 : `sudo apt-get install -y python3-pip`
    9) luarocks : `sudo apt-get install -y luarocks`
    10) npm : `sudo apt-get install -y nodejs npm` (v12.22.9 TLS)
2. nvim-treesitter.nvim
    1) tree-sitter
    2) node : `sudo apt-get install -y nodejs`
    3) git
    4) gcc : `sudo apt-get install -y build-essential`
3. provider
    1) python3 provider :
        - install python-venv : `sudo apt-get install -y python3-venv`
        - activate venv : `source ~/.config/.Nvim_venv/bin/activate`
        - install neovim : `pip install neovim` in venv (`pynvim` is installed automatically)
        - If you want to execute nvim in python virtualenv, run nvim after activate venv
    2) nodejs provider :
        - `apt` install old v12.22.9 and `neovim` package requires >= v14
            - use `nvm` instead of `apt` for newer version of nodejs
        - install nvm : `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash`
            - it will add $NVM_DIR in .zshrc
            - execute .zshrc : `source ~/.zshrc`
        - show which version can be used : `nvm list-remote`
        - show which version installed : `nvm list`
        - install nodejs & npm : `nvm install v20.14.0` (`npm v10.7.0` will be installed automatically)
        - install neovim from npm : `npm install -g neovim` ( confirm global installed packages with `npm -g ls` )

## queries

### *1. Rainbow Delimiters for matlab*
Delimiter file for matlab was written in `nvim_config/query/rainbow-delimiters.nvim/matlab/`
and it can be used in [HiPhish/rainbow-delimiters.nvim](https://github.com/HiPhish/rainbow-delimiters.nvim)
To use, follow these step

1) Add matlab query directory to `nvim-data/lazy/rainbow-delimiters.nvim/queries`


### *2. nvim-treesitter-endwise for matlab*
I'm making endwise file for matlab in `nvim_config/query/nvim-treesitter-endwise/matlab/`
(In Proceeding)


### *3. Luasnip for matlab*

I'm making snippet file for matlab in `nvim_config/queries/friendly-snippets/matlab/`
using [friendly-snippets](https://github.com/rafamadriz/friendly-snippets),
These steps will operate automatically later, every update of github repository or I'll find other ways

1) Add matlab query directory to `nvim-data/lazy/friendly-snippets/snippets`
2) Add this code in `nvim-data/lazy/friendly-snippets/package.json`

```json
{
    "language": ["matlab"],
    "path": "./snippets/matlab/matlab.json"
},
```

(In Proceeding)
