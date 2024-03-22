# nvim_config


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
