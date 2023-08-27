local lsp = require("lsp-zero").preset("recommended")
lsp.extend_cmp()

local cmp = require('cmp')
local cmp_select_opts = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
	mapping = {
		['<C-y>'] = cmp.mapping.confirm({select = true}),
		['<CR>'] = cmp.mapping.confirm({select = true}),
		['<C-c>'] = cmp.mapping.abort(),
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
		['<Up>'] = cmp.mapping.select_prev_item(cmp_select_opts),
		['<Down>'] = cmp.mapping.select_next_item(cmp_select_opts),
		['<C-p>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item(cmp_select_opts)
			else
				cmp.complete()
			end
		end),
		['<C-n>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_next_item(cmp_select_opts)
			else
				cmp.complete()
			end
		end),
	},
})

lsp.on_attach(function(_, bufnr)
    -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#default_keymapsopts
	lsp.default_keymaps({buffer = bufnr}) -- add lsp-zero defaults
	local nmap = function(keys, func, desc)
		if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
end)

lsp.format_on_save({
    format_opts = {
        async = true,
        -- timeout_ms = 10000,
    },
    servers = {
        ['lua_ls'] = {'lua'},
        ['gopls'] = {'go'},
        -- if you have a working setup with null-ls
        -- you can specify filetypes it can format.
        -- ['null-ls'] = {'javascript', 'typescript'},
    }
})

-- Fix Undefined global 'vim'
require('lspconfig').lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

lsp.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»'
})


lsp.setup()
