" Modified by Patrick Günther
"


" The default vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2020 Sep 30
"
" This is loaded if no vimrc file was found.
" Except when Vim is run with "-u NONE" or "-C".
" Individual settings can be reverted with ":set option&".
" Other commands can be reverted as mentioned below.

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Bail out if something that ran earlier, e.g. a system wide vimrc, does not
" want Vim to use these default values.
if exists('skip_defaults_vim')
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
  set guioptions-=t
endif

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
" Only xterm can grab the mouse events when using the shift key, for other
" terminals use ":", select text and press Esc.
if has('mouse')
  if &term =~ 'xterm'
    set mouse=a
  else
    set mouse=nvi
  endif
endif

" Only do this part when Vim was compiled with the +eval feature.
if 1

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

  augroup END

endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  syntax on

  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

" ****************
" End of default config file
" ****************

set number
set expandtab

set encoding=utf-8
" set clipboard=unnamedplus

" Remap pane switching
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright

" show leader key trigger
set showcmd

" set leader
let mapleader = " "


" Settings for preservim/tagbar plugin
set shell=/usr/bin/bash
nmap <leader>t :TagbarToggle<CR>
nmap <leader>T :TagbarTogglePause<CR>
let g:tagbar_show_data_type=1

set ssop-=options    " do not store global and local values in a session

" Settings for vim-workspace
let g:workspace_session_directory = $HOME . '/.vim/sessions/'
nnoremap <leader>s :ToggleWorkspace<CR>

" Folding (see https://www.vimfromscratch.com/articles/vim-folding/)
set foldmethod=indent
autocmd BufWinEnter * silent! :%foldopen! " Automatically unfold 

" Settings for indentation detection
let g:yaifa_expandtab = 1 " Use spaces
let g:yaifa_shiftwidth = 4 " use 4 wide tabs 
let g:yaifa_tabstop = 4
let g:tabstop = 4

" Re-indent to 4 spaces
function! ReIndent()
  set shiftwidth=4 
  set softtabstop=4
  set expandtab
  call feedkeys("gg=G<C-o><C-o>")
endfunction

" Allow saving of files with sudo
" https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
cmap w!! w !sudo tee > /dev/null %

" Indent guide settings
" let g:indent_guides_start_level = 0
" let g:indent_guides_guide_size = 1
let g:indentguides_firstlevel = 1 " enable first-level guides
let g:indentguides_toggleListMode = 0 "disable $ at EOL

" Highlight cursor position
" set cursorcolumn
" set cursorline

" Set hidden for ctrl+space plugin
set hidden
set nocompatible
set encoding=utf-8

set updatetime=100 " reduced because of gitgutter

" auto save options
let g:auto_save = 1
let g:auto_save_no_updatetime = 1
let g:auto_save_in_insert_mode = 0

" Status bar config

function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction

let g:airline_section_b = '%{fugitive#statusline()} %{GitStatus()}'
"
" option for ctrlspace
let g:airline_exclude_preview = 1
"
"
" download vim-plug if missing https://yadm.io/docs/bootstrap
if empty(glob("~/.vim/autoload/plug.vim"))
  silent! execute '!curl --create-dirs -fsSLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall
endif

silent! if plug#begin('~/.vim/plugged')

" Make sure you use single quotes
" NERDTree
" Plug 'https://github.com/preservim/nerdtree'

" Indentation guides
" Plug 'https://github.com/thaerkh/vim-indentguides'
" Plug 'https://github.com/nathanaelkane/vim-indent-guides'

" 
Plug 'https://github.com/preservim/tagbar'

" Parantheses
Plug 'https://github.com/tpope/vim-surround'

" Search/finder
" Plug 'https://github.com/ctrlpvim/ctrlp.vim'

" Easy alignment
Plug 'junegunn/vim-easy-align'

" Shows " and @ previews
Plug 'https://github.com/junegunn/vim-peekaboo'
Plug 'Yilin-Yang/vim-markbar'

" Workspace
"Plug 'https://github.com/thaerkh/vim-workspace'

" Indentation detection
Plug 'https://github.com/Raimondi/yaifa'

" Git
" highlight changed lines
Plug 'airblade/vim-gitgutter'
" access git functions
Plug 'tpope/vim-fugitive'
" show changes and commit selectively
Plug 'jreybert/vimagit'

" status line
Plug 'vim-airline/vim-airline'

"
Plug 'easymotion/vim-easymotion'

" Scrolling nice
Plug 'joeytwiddle/sexy_scroller.vim'


Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-vinegar'

"
"Plug 'liuchengxu/vim-which-key'

" Plug 'valloric/youcompleteme'
Plug 'vim-ctrlspace/vim-ctrlspace'

Plug 'vim-scripts/vim-auto-save'

Plug 'lervag/vimtex'

" auto tag files
Plug 'xolox/vim-easytags'
Plug 'xolox/vim-misc'

" change indent
Plug 'ruyadorno/vim-change-indent'

" auto numbers
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" move objects
Plug 'matze/vim-move'

" complete
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" store folds
"Plug 'zhimsel/vim-stay'

" Color schemes (unused)
"Plug 'nanotech/jellybeans.vim'
"Plug 'blackgate/tropikos-vim-theme'
"Plug 'vim-scripts/desertink.vim'
"Plug 'chriskempson/base16-vim'
"Plug 'arzg/vim-colors-xcode'
"Plug 'sainnhe/sonokai'
"Plug 'atahabaki/archman-vim'
"Plug 'w0ng/vim-hybrid'
"Plug 'ParamagicDev/vim-medic_chalk'
"Plug 'victorze/foo'
"Plug 'jdsimcoe/hyper.vim'
"Plug 'jdsimcoe/panic.vim'
"Plug 'tpope/vim-vividchalk'
"Plug 'ts-26a/vim-darkspace'


" Initialize plugin system
call plug#end()

endif

let g:CtrlSpaceDefaultMappingKey = "<leader>f"
"if has("gui_running")
"    " Settings for MacVim and Inconsolata font
"    let g:CtrlSpaceSymbols = { "File": "◯", "CTab": "▣", "Tabs": "▢" }
"endif
if executable("ag")
    let g:CtrlSpaceGlobCommand = 'ag -l --nocolor -g ""'
endif

" Map fuzzy finder to leader-a
nmap <leader>a :Ag<CR>

let g:CtrlSpaceCacheDir = "/home/patrick/.vim/cs_cache"
let g:CtrlSpaceSaveWorkspaceOnExit = 1
let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
let g:CtrlSpaceLoadLastWorkspaceOnStart = 1


" configure vim-stay
"set viewoptions=cursor,folds,slash,unix
"set sessionoptions+=folds

" git shortcut
nnoremap <leader>g :Magit<CR>

" show marks when using them
nnoremap ~ :<C-u>marks<CR>:normal! `
nnoremap <leader>` :Marks<CR>

" conceal commands
nmap <leader>c :call ConcealToggle()<CR>

" https://learnvimscriptthehardway.stevelosh.com/chapters/38.html
function! ConcealToggle()
    if &conceallevel
        setlocal conceallevel=0
    else
        setlocal conceallevel=2
    endif
endfunction

" fix mouse for use with alacritty terminal emulator
set ttymouse=sgr

" enable colorscheme
set termguicolors
colorscheme haug

" No indentguides for tex files (because conceals are set to a highlight
" color)
let g:indentguides_ignorelist = ['tex']

" Return Syntax Stack under cursor https://stackoverflow.com/a/9464929/2581056
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Return Syntax Group under cursor https://stackoverflow.com/a/37040415/2581056
function! SynGroup()                                                            
    let l:s = synID(line('.'), col('.'), 1)                                       
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun



function! SynStack2 ()
    for i1 in synstack(line("."), col("."))
        let i2 = synIDtrans(i1)
        let n1 = synIDattr(i1, "name")
        let n2 = synIDattr(i2, "name")
        echo n1 "->" n2
    endfor
endfunction

" SexyScroller values
let g:SexyScroller_MaxTime=800
let g:SexyScroller_EasingStyle=3
let g:SexyScroller_ScrollTime=8
let g:SexyScroller_MinLines = 30
let g:SexyScroller_MinColumns = 200

" easymotion to localleader
map <localleader> <Plug>(easymotion-prefix)

" Vimtex
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_forward_search_on_start = 1
if empty(v:servername) && exists('*remote_startserver')
  call remote_startserver('VIM')
endif

" disable concealing the cursor line
set concealcursor= 

" enable conceal as default
set conceallevel=2

" prevent indentguides plugin from re-setting concealcursor option
let g:indentguides_concealcursor_unaltered = ""

" xonsh script autocmd
autocmd BufReadPost *.xsh  set filetype=python
autocmd BufReadPost *.xonsh  set filetype=python

" fast window switching
map <C-W><C-L> <C-W>l<C-W><Bar>
map <C-W><C-J> <C-W>j<C-W><Bar>
map <C-W><C-K> <C-W>k<C-W><Bar>
map <C-W><C-H> <C-W>h<C-W><Bar>
map <C-W><C-F> <C-W><Bar>

" matze/vim-move
let g:move_key_modifier = 'C'

" load Coc settings
" source ~/.vim/coc-settings.vim
"

" Biber maurice
let g:Tex_BibtexFlavor = 'biber'
let g:Tex_DefaultTargetFormat="pdf"
" The following is relevant to make LaTeX rerun after biber if necessary: 
" (include all formats for which re-running is to be enabled)
let g:Tex_MultipleCompileFormats='pdf,dvi'
