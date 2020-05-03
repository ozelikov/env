" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set encoding=utf-8

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Yggdroot/indentLine'
call plug#end()

if filereadable(expand("~/.fzf.bash"))
    inoremap <expr> <c-x><c-k> fzf#vim#complete('cat /usr/share/dict/words')
endif

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif


" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup    " don't create backup files
set history=50  " keep 50 lines of command line history
set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands
set incsearch   " do incremental searching
set number      " show line numbers
set ignorecase  " ignore case in pattern
set mouse=a     " enable mouse

set term=screen-256color
set t_Co=256
set t_ut=

set shellslash  " use '/' when expanding filenames
set expandtab   
set smarttab
set tabstop=4
set shiftwidth=4

set visualbell
set foldcolumn=2
set confirm

"set clipboard=unnamedplus

"setlocal foldmethod=syntax

" Persist the undo tree for each file
set undofile
set undodir^=~/.vim/undo//

"command Paste execute 'set noai | insert | set ai'

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

set wildmenu  "autocomplete like bash
"set wildmode=list:longest

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  filetype plugin indent on
  if ! &diff
    augroup vimrcEx
    au!
  
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
  
    augroup END
  endif

else

  set autoindent        " always set autoindenting on

endif " has("autocmd")


set textwidth=100
"autocmd Syntax * syn match cSpaceError /\%>100v.\+/ containedin=ALL
" For all C, C++ files set 'textwidth' to 100 characters.
autocmd FileType c setlocal textwidth=100
autocmd FileType cpp setlocal textwidth=100
" For all C, C++ files set 'shiftwidth' to 4 characters.
autocmd FileType c setlocal shiftwidth=4
autocmd FileType cpp setlocal shiftwidth=4
autocmd FileType sh setlocal shiftwidth=4
autocmd FileType c set cino=(s,u0,U1,l1
autocmd FileType cpp set cino=(s,u0,U1,g0,N-s,E-s,l1
autocmd FileType perl setlocal shiftwidth=4
" For all text files set 'shiftwidth' to 2 characters.
autocmd FileType text setlocal shiftwidth=2 textwidth=79

let c_space_errors=1

" do not ident on #
"autocmd FileType c set cink="0{,0},0),:,0,!^F,o,O,e"
"autocmd FileType cpp set cink="0{,0},0),:,0,!^F,o,O,e"

" ***************************************
" indentLine
" ***************************************
let g:indentLine_char_list = ['.']

" ***************************************
" GIT TOOLS
" ***************************************
function! OGitBranch()
    if filereadable(expand(".git/HEAD"))
        for line in readfile(".git/HEAD", '', 1)
            return substitute(line, '.*/', '', 'g')
        endfor
    endif
    return ''
endfunction

function! OMakeGitDiffView()
    if filereadable(expand(".git/HEAD"))
        :enew
        :set buftype=nofile
        :r !git status -sb
    endif
endfunction

" ***************************************
" STATUSLINE 
" ***************************************
set laststatus=2
set statusline +=%{OGitBranch()}
set statusline +=\ %<%F            "full path
set statusline +=\ %m\ %r          "modified flag
set statusline +=%=%5l             "current line
set statusline +=/%L               "total lines
set statusline +=%4v\              "virtual column number
" hi User1 guifg=#292b00  guibg=#f4f597

" ***************************************
" QUICKFIX 
" ***************************************
" ignore warnings
set errorformat^=%-G%f:%l:\ warning:%m


" ***************************************
" MAPPINGS 
" ***************************************
" Esc
"imap <C-Space> <Esc>

" split navigation
map <C-l> :wincmd l<cr>
map <C-h> :wincmd h<cr>
map <C-k> :wincmd k<cr>
map <C-j> :wincmd j<cr>
imap <C-l> <Esc> :wincmd l<cr>
imap <C-h> <Esc> :wincmd h<cr>
imap <C-k> <Esc> :wincmd k<cr>
imap <C-j> <Esc> :wincmd j<cr>

map <C-S-l>  :vertical res +3<cr>
map <C-S-h>  :vertical res -3<cr>
map <C-S-k>  :res +2<cr>
map <C-S-j>  :res -2<cr>


map <C-F1> :b1<CR>
map <F2> :Explore<CR>

map <F3> :b1<CR>

map <A-F4> :q<CR>
map <F4> :call OMakeGitDiffView() <CR>

map <F6> :buffers<CR>:e #

" quickfix shortcuts
map <F7> :cf .errfile.tmp<CR>
map <S-F7> :cl<CR>
map <C-F7> :cn<CR>
map <C-S-F7> :cp<CR>


map <S-F9> :setlocal spell! spelllang=en_us<CR>
imap <S-F9> <C-o>:setlocal spell! spelllang=en_us<CR>

map <S-Left> :bp<CR>
map <S-Right> :bn<CR>

nmap <C-P> :Files<CR>

"iunmap <C-y>
"unmap <C-a>

" ***************************************
"  NETRW
" ***************************************
"let g:netrw_banner = 0
"let g:netrw_liststyle = 3
"let g:netrw_browse_split = 3
"let g:netrw_altv = 1
"let g:netrw_winsize = 25
let g:netrw_list_hide= '.*\.swp$,^\.git$,^\..*$,\~$'

" ***************************************
"  CSCOPE
" ***************************************
if filereadable(expand("~/.vim/cscope_maps.vim"))
    source ~/.vim/cscope_maps.vim
endif

" ***************************************
"  COLORS and FONTS
" ***************************************
:color peachpuff
set guifont=Monospace\ 11
"set guifont=Lucida_Console:h12
"set guifont=DejaVu_Sans_Mono:h11:cANSI
"set guifont=-adecw-screen-medium-r-normal--14-140-75-75-m-70-iso8859-1

if &t_Co > 255
hi Normal ctermbg=223 ctermfg=16 guibg=PeachPuff guifg=Black
hi SpecialKey term=bold ctermfg=4 guifg=Blue
hi NonText term=bold cterm=bold ctermfg=4 gui=bold guifg=Blue
hi Directory term=bold ctermfg=4 guifg=Blue
hi ErrorMsg term=standout cterm=bold ctermfg=7 ctermbg=1 gui=bold guifg=White guibg=Red
hi IncSearch term=reverse cterm=reverse gui=reverse
hi Search term=reverse ctermbg=226 guibg=Gold2
hi MoreMsg term=bold ctermfg=2 gui=bold guifg=SeaGreen
hi ModeMsg term=bold cterm=bold gui=bold
hi LineNr term=underline ctermfg=3 guifg=Red3
hi Question term=standout ctermfg=47 gui=bold guifg=SeaGreen
hi StatusLine term=bold,reverse cterm=bold,reverse gui=bold guifg=White guibg=Black
hi StatusLineNC term=reverse cterm=reverse gui=bold guifg=PeachPuff guibg=Gray45
hi VertSplit term=reverse cterm=reverse gui=bold guifg=White guibg=Gray45
hi Title term=bold ctermfg=5 gui=bold guifg=DeepPink3
hi Visual term=reverse cterm=reverse ctermfg=249 ctermbg=fg gui=reverse guifg=Grey80 guibg=fg
hi VisualNOS term=bold,underline cterm=bold,underline gui=bold,underline
hi WarningMsg term=standout ctermfg=1 gui=bold guifg=Red
hi WildMenu term=standout ctermfg=0 ctermbg=3 guifg=Black guibg=Yellow
hi Folded term=standout ctermfg=4 ctermbg=7 guifg=Black guibg=#e3c1a5
hi FoldColumn term=standout ctermfg=4 ctermbg=7 guifg=DarkBlue guibg=Gray80
hi DiffAdd term=bold ctermbg=223 guibg=White
hi DiffChange term=bold ctermbg=223 guibg=#edb5cd
hi DiffDelete term=bold cterm=bold ctermfg=4 ctermbg=217 gui=bold guifg=LightBlue guibg=#f6e8d0
hi DiffText term=reverse cterm=bold ctermbg=229 gui=bold guibg=#ff8060
hi Cursor guifg=bg guibg=fg 
hi lCursor guifg=bg guibg=fg

" Colors for syntax highlighting
hi Comment term=bold ctermfg=4 guifg=#406090
hi Constant term=underline ctermfg=1 guifg=#c00058
hi Special term=bold ctermfg=5 guifg=SlateBlue
hi Identifier term=underline ctermfg=6 guifg=DarkCyan
hi Statement term=bold cterm=bold ctermfg=88 gui=bold guifg=Brown
hi PreProc term=underline ctermfg=128 guifg=Magenta3
hi Type term=underline cterm=bold ctermfg=35 gui=bold guifg=SeaGreen
hi Ignore cterm=bold ctermfg=7 guifg=bg
hi Error term=reverse cterm=bold ctermfg=7 ctermbg=1 gui=bold guifg=White guibg=Red
hi Todo term=standout ctermfg=0 ctermbg=11 guifg=Blue guibg=Yellow
hi cSpaceError ctermbg=250 ctermfg=16 
endif

":color delek

" ***************************************
"  DIFF MODE
" ***************************************
:if &diff
map <C-F1> :set diffopt^=iwhite<CR>
set noro
set noswapfile
hi Normal ctermbg=250 ctermfg=16 
" ignore whitespace in diff mode
map <F4> :match Ignore /\r$/<CR>
nnoremap ZZ :wqa<CR>
nnoremap XX :qa<CR>
nnoremap <C-q> :qa<CR>
map <C-n> ]czz
map <C-b> [czz
:endif

" My Tips
"
" :mk[exrc] [file]    Write current key mappings and changed options to
"                     [file] (default ".exrc" in the current directory),
"                     unless it already exists.
" :version            
" :echo $VIMRUNTIME  
"
