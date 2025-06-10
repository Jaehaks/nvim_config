# nvim_config

- Default setup :
    - Windows 10
    -

## Installation requirement

### For Windows

#### pre-required environment variable


1. `HOME` : `%USERPROFILE%`
2. `PATH` :
	- `%USERPROFILE%\.config\Dotfiles\clink`
	- `%USERPROFILE%\user_installed\SumatraPDF`
	- `%USERPROFILE%\user_installed\<clinkpath>`
	- `%USERPROFILE%\user_installed\MikTeX\miktex\bin\x64`
	- `%USERPROFILE%\scoop\apps\openjdk11\current\bin`
	- `%USERPROFILE%\Vim\vim90`
	- `%USERPROFILE%\user_installed\node-v24.2.0-win-x64` (for nvim-treesitter's main branch)
3. `CC` : `gcc` (for nvim-treesitter's main branch)
4. `XDG_CONFIG_HOME` : `%USERPROFILE%\.config`
5. `XDG_DATA_HOME` : `%USERPROFILE%\.config`
6. `XDG__HOME` : `%USERPROFILE%\.config`
7. `XDG_RUNTIME_DIR` : `C:\WINDOWS\TEMP\nvim.user`

#### using `scoop`

> [!NOTE]
> To add buckets put this code in cmd prompt
> `scoop bucket add main extras versions java`

```powershell
	scoop install ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick bat clipboard unar wget curl unzip gzip tar pwsh openjdk11 go rustup python tree-sitter git gh
	scoop install lua luarocks mingw neovim neovim-qt iconv uutils-coreutils less sed grep obs-studio scoop-search ghostscript windows-terminal yazi zip eza gawk
```

1. [ffmpeg](https://github.com/FFmpeg/FFmpeg) (for yazi)
2. [7zip](https://7-zip.org/) (for yazi, neovim/mason)
3. [jq](https://github.com/jqlang/jq) (for yazi)
4. [poppler](https://github.com/davidben/poppler) (for yazi)
5. [fd](https://github.com/sharkdp/fd) (for yazi, neovim/snacks)
6. [ripgrep](https://github.com/BurntSushi/ripgrep) (for yazi, neovim/snacks)
7. [fzf](https://github.com/junegunn/fzf) (for yazi)
8. [zoxide](https://github.com/ajeetdsouza/zoxide) (for yazi, clink)
9. [resvg](https://github.com/linebender/resvg) (for yazi)
10. [imagemagick](https://github.com/ImageMagick/ImageMagick) (for yazi)
11. [bat](https://github.com/sharkdp/bat) (for yazi)
12. [clipboard](https://github.com/Slackadays/Clipboard) (for yazi)
13. [unar](https://theunarchiver.com/command-line) (for yazi/lsar.yazi)
14. [wget](https://github.com/mirror/wget) (for neovim/mason)
15. [curl](https://github.com/curl/curl) (for neovim/mason)
16. [unzip](https://infozip.sourceforge.net/) (for neovim/mason)
17. [gzip](https://www.mingw-w64.org/) (for neovim/mason)
18. [tar](https://www.mingw-w64.org/) (for neovim/mason)
19. [pwsh](https://github.com/PowerShell/PowerShell) (for neovim/mason)
	- or [download link](https://github.com/PowerShell/PowerShell/releases)
20. [openjdk11](https://github.com/openjdk/jdk11u) (for neovim/mason)
21. [go](https://github.com/golang/go) (for neovim/go)
22. [rustup](https://github.com/rust-lang/rustup) (for neovim/mason)
23. [python](https://www.python.org/) (for neovim/mason, neovim provider)
24. [tree-sitter](https://tree-sitter.github.io/tree-sitter/) (for neovim/nvim-treesitter) (0.25.0 or later for nvim-treesitter's main branch)
25. [git](https://github.com/git/git) (for neovim/lazy.nvim, neovim/snacks)
26. [gh](https://cli.github.com/) (for neovim/blink-cmp-git)
27. [lua](https://github.com/LuaLS/lua-language-server) (for neovim)
28. [luarocks](https://luarocks.org/) (for neovim)
29. [mingw](https://www.mingw-w64.org/) (for neovim)
	- gcc (for neovim/nvim-treesitter main branch), set `CC` to gcc for using c compiler
30. [neovim](https://github.com/neovim/neovim) (for neovim)
31. [neovim-qt](https://github.com/equalsraf/neovim-qt) (for neovim)
32. [iconv](https://github.com/processone/iconv) (for `clink/fzff.cmd` and `clink/fzfd.cmd`)
33. [uutils-coreutils](https://github.com/uutils/coreutils) (for linux command)
34. [less](https://www.greenwoodsoftware.com/less/) (for linux command)
35. [sed](https://www.gnu.org/software/sed) (for linux command)
36. [grep](https://www.gnu.org/software/grep) (for linux command)
37. [obs-studio](https://obsproject.com/) (for recording screen)
38. [scoop-search](https://github.com/shilangyu/scoop-search) (for search scoop package)
39. [ghostscript](https://www.ghostscript.com/)
40. [windows-terminal](https://github.com/microsoft/terminal)
41. [yazi](https://github.com/sxyazi/yazi)
42. [zip](https://infozip.sourceforge.net/)
43. [eza](https://github.com/eza-community/eza)
44. [gawk](https://sourceforge.net/projects/ezwinports/)

#### using manual download

1. [sumatraPDF](https://www.sumatrapdfreader.org/free-pdf-reader)
	- program from `scoop` has some bug
2. [clink](https://github.com/chrisant996/clink/releases)
	- it needs to copy or link files from `dotfiles` to the install path of clink
3. [node.js](https://nodejs.org/ko/download) (for neovim/mason)
	- select version `> v23.x` for `nvim-treesitter's main branch` and download portable version for convenient installation
	- npm (for neovim/mason)
		- `npm install -g neovim` for `vim.g.loaded_node_provider = 1`
		- `vim.g.loaded_perl_provider = 0` for disable provider warning
4. [MikTeX](https://miktex.org/download)
	- `pdflatex` for `snacks`
	- `latexmk` for `vimtex`
	- It is more convenient to install packages over than `scoop` package
5. [Obsidian](https://obsidian.md/download)
	- for personal markdown notes

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
