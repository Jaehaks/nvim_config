# nvim_config

- Default setup :
    - Windows 10
    -

## Installation requirement

### For Windows

#### using `scoop`

> [!NOTE]
> To add buckets put this code in cmd prompt
> `scoop bucket add main extras versions java`

```powershell
	scoop 7zip bat clipboard cmake curl eza fd fzf gawk gho
```

1. ffmpeg (for yazi)
2. 7zip (for yazi, neovim/mason)
3. jq (for yazi)
4. poppler (for yazi)
5. fd (for yazi, neovim/snacks)
6. ripgrep (for yazi, neovim/snacks)
7. fzf (for yazi)
8. zoxide (for yazi, clink)
9. resvg (for yazi)
10. imagemagick (for yazi)
11. bat (for yazi)
12. clipboard (for yazi)
13. unar (for yazi/lsar.yazi)
14. wget (for neovim/mason)
15. curl (for neovim/mason)
16. unzip (for neovim/mason)
17. gzip (for neovim/mason)
18. tar (for neovim/mason)
19. pwsh (for neovim/mason)
	- or [download link](https://github.com/PowerShell/PowerShell/releases)
20. openjdk11 (for neovim/mason)
21. go (for neovim/go)
22. rustup (for neovim/mason)
23. python (for neovim/mason, neovim provider)
24. tree-sitter (for neovim/nvim-treesitter)
25. git (for neovim/lazy.nvim, neovim/snacks)
26. lua (for neovim)
27. luarocks (for neovim)
28. mingw (for neovim)
	- gcc (for neovim/nvim-treesitter)
29. neovim (for neovim)
30. neovim-qt (for neovim)
31. iconv (for `clink/fzff.cmd` and `clink/fzfd.cmd`)
32. uutils-coreutils (for linux command)
33. less (for linux command)
34. sed (for linux command)
35. grep (for linux command)
36. obs-studio (for recording screen)
35. scoop-search (for search scoop package)
37. ghostscript
38. windows-terminal
39. yazi
40. zip
41. eza
42. gawk

#### using manual download

1. [sumatraPDF](https://www.sumatrapdfreader.org/free-pdf-reader)
	- program from `scoop` has some bug
2. [clink](https://github.com/chrisant996/clink/releases)
	- it needs to copy or link files from `dotfiles` to the install path of clink
3. [node.js](https://nodejs.org/ko/download) (for neovim/mason)
	- version v20
	- npm (for neovim/mason)
		- `npm install -g neovim` for `vim.g.loaded_node_provider = 1`
		- `vim.g.loaded_perl_provider = 0` for disable provider warning
4. [MikTeX](https://miktex.org/download)
	- `pdflatex` for `snacks`
	- `latexmk` for `vimtex`
	- It is more convenient to install packages over than `scoop` package



#### mason

- `mason` is loaded by `cmd` for lazy load. Parsers must be installed manually

* 🟩 required lsp
	- json-lsp
	- basedpyright
	- lua-language-server
	- matlab-languager-server

* 🟩 required linter
	- ruff

* 🟩 required formatter
	- latexindent
	- stylua

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
