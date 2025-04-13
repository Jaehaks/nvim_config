
lspconfig.ruff.setup({ -- use ruff as python linter
  on_attach = function (client, bufnr)
    -- lsp use ruff to formatter
    client.server_capabilities.documentFormattingProvider = false      -- enable vim.lsp.buf.format()
    client.server_capabilities.documentRangeFormattingProvider = false -- formatting will be used by confirm.nvim
    client.server_capabilities.hoverProvider = false                   -- use pylsp
  end,
  -- cmp_nvim_lsp default_configuration add completionProvider. ruff_lsp don't use completion
  filetype = {'python'},
  root_dir = function (fname)
    return lsp_util.root_pattern('.git')(fname) or vim.fn.getcwd()
  end,
  single_file_support = true,
  init_options = {
    settings = {
      configuration = paths.lsp.ruff.config_path,
      logFile = paths.lsp.ruff.log_path,
      logLevel = 'warn',
      organizeImports = true, -- use code action for organizeImports
      showSyntaxErrors = true, -- show syntax error diagnostics
      codeAction = {
        disableRuleComment = { enable = false }, -- show code action about rule disabling
        fixViolation = { enable = false }, -- show code action for autofix violation
      },
      format = {			-- use conform.nvim
        preview = false,
      },
      lint = {            -- it links with ruff, but lint.args are different with ruff configuration
        enable = true,
      },
    }
  },
  handlers = {
    -- ['textDocument/publishDiagnostics'] = create_custom_handler(sign_priority.rank1)
    ['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = false,
    }
    )
  }
})

return {
  'saghen/blink.cmp',
  version = '1.*',
  event = 'InsertEnter',
  opts = {
    keymap = { preset = 'default' },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
      keyword = {
        range = 'prefix',
      },
      documentation = {
        auto_show = true
      },
    },
    sources = {
      default = {'lsp', 'path', 'snippets', 'buffer'},
      per_filetype = {
        lua = {'lsp', 'buffer'}
      },
      min_keyword_length = 0,
    },
    -- fuzzy = {
      -- 	implementation = 'prefer_rust_with_warning'
      -- }
    },
    opts_extend = {
      'sources.default'
    },
    config = function ()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      vim.lsp.config['*'] = {
        capabilities = capabilities,
      }
    end

  }
