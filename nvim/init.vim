let mapleader=" "
set list
syntax on
let g:html_indent_script1 = "inc" 
let g:html_indent_style1 = "inc" 
set relativenumber
set tabstop=2
set shiftwidth=2
set nu
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set termguicolors
set scrolloff=8
set noshowmode
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

call plug#begin('~/.vim/plugged')
Plug 'gruvbox-community/gruvbox'
" Plug 'colepeters/spacemacs-theme.vim'
Plug 'sainnhe/gruvbox-material'
" Plug 'phanviet/vim-monokai-pro'
Plug 'vim-airline/vim-airline'
Plug 'flazz/vim-colorschemes'
Plug 'ap/vim-css-color'
Plug 'airblade/vim-rooter'

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.2' }
Plug 'ThePrimeagen/harpoon'
Plug 'nvim-telescope/telescope-live-grep-args.nvim'

" LSP Support
Plug 'neovim/nvim-lspconfig'             " Required
Plug 'williamboman/mason.nvim',          " Optional
Plug 'williamboman/mason-lspconfig.nvim' " Optional

" Autocompletion
Plug 'hrsh7th/nvim-cmp'     " Required
Plug 'hrsh7th/cmp-nvim-lsp' " Required
Plug 'L3MON4D3/LuaSnip'     " Required

Plug 'stevearc/oil.nvim'
Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v2.x'}

Plug 'praem90/nvim-phpcsf'

call plug#end()

let g:nvim_phpcs_config_phpcs_path = '/var/www/html/praeconis/vendor/bin/phpcs'
let g:nvim_phpcs_config_phpcbf_path = '/var/www/html/praeconis/vendor/bin/phpcbf'
let g:nvim_phpcs_config_phpcs_standard = 'Drupal' " or path to your ruleset phpcs.xml
augroup PHBSCF
	autocmd!
	autocmd BufWritePost,BufReadPost,InsertLeave *.php :lua require'phpcs'.cs()
	autocmd BufWritePost *.php :lua require'phpcs'.cbf()
augroup END


nnoremap <Esc> :noh<CR>
noremap <C-i> <Nop>

" Remapper Ctrl+O pour aller au fichier précédent dans l'historique
nnoremap <C-o> :bprevious<CR>

" Remapper Ctrl+I pour aller au fichier suivant dans l'historique
nnoremap <C-i> :bnext<CR>
" Theme
let g:gruvbox_invert_selection='0'
set background=dark
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox
let g:rooter_patterns = ['Makefile', '*.sln', 'build/env.sh', 'deploy.sh']

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Harpoon
nnoremap <leader>a <cmd>lua require("harpoon.mark").add_file()<cr>
nnoremap <leader><leader> <cmd>:lua require("harpoon.ui").toggle_quick_menu()<cr>

" Fichier
" Fonction pour ouvrir Dolphin dans le répertoire du fichier courant
function! OpenDolphin()
	let l:current_file = expand('%:p')
	let l:current_directory = fnamemodify(l:current_file, ':p:h')
	silent execute "!dolphin" shellescape(l:current_directory)
endfunction

" Associez la fonction OpenDolphin à la combinaison de touches Ctrl+P
nnoremap <C-S-P> :call OpenDolphin()<CR>

lua<<OEF

require("oil").setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

local lsp = require('lsp-zero').preset({})


lsp.on_attach(function(client, bufnr)
-- see :help lsp-zero-keybindings
-- to learn the available actions
lsp.default_keymaps({buffer = bufnr})
end)

lsp.setup()

-- You need to setup `cmp` after lsp-zero
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
mapping = {
	-- `Enter` key to confirm completion
	['<CR>'] = cmp.mapping.confirm({select = false}),

	-- Ctrl+Space to trigger completion menu
	['<C-Space>'] = cmp.mapping.complete(),

	-- Navigate between snippet placeholder
	['<C-f>'] = cmp_action.luasnip_jump_forward(),
	['<C-b>'] = cmp_action.luasnip_jump_backward(),
	['<Tab>'] = function(fallback)
	if cmp.visible() then
		cmp.select_next_item()
	else
		fallback()
		end
		end,
		['<S-Tab>'] = function(fallback)
		if cmp.visible() then
			cmp.select_prev_item()
		else
			fallback()
			end
			end
}
})

