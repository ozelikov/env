" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set encoding=utf-8

if filereadable(expand("~/.vim/autoload/plug.vim"))
    call plug#begin('~/.vim/plugged')
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'christoomey/vim-tmux-navigator'
    "Plug 'tpope/vim-fugitive'
    "Plug 'Yggdroot/indentLine'
    Plug 'vim-scripts/indentpython.vim'
    call plug#end()
endif

if exists('$TMUX')
    let g:fzf_layout = { 'tmux': '-p90%,60%' }
else
    let g:fzf_layout = { 'window': '-tabnew' }
endif

if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

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

set clipboard+=unnamed

"setlocal foldmethod=syntax

" Persist the undo tree for each file
set undofile
set undodir^=~/.vim/undo//

"command Paste execute 'set paste | insert | set nopaste'

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
"autocmd FileType python set cino=(0
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
    " Example of command:
    ":enew | set bt=nofile | r !git log -1 --stat

    if filereadable(expand(".git/HEAD"))
        :enew
        :set buftype=nofile
        :r !git status -sb
    endif
endfunction

function! OGrep()
    " Example of command:
    ":enew | set bt=nofile | r !git log -1 --stat
    :let text = system("git grep -wn " . expand("<cword>"))
    :enew
    :set buftype=nofile
    :put=text
endfunction

function! OGitBlame(file)
    " Example of command:
    ":enew | set bt=nofile | r !git blame <file>
    " Format
    "e0d2e45d pmd/main.cpp (<ozelikov@aaa.com> 2020-07-29 15:44:15 +0300  54) #include <stdio.h>
    :let regex = 's/(^\S+)\s+\S+\s+\(<(\w+)\S+(\s+\S+).*?\)/$1 $2 $3/'
    :let text = system("git blame -ef " . a:file ." | perl -npe '" . regex . "'")
    :set scrollbind
    :vsplit
    :enew
    :set buftype=nofile
    :put!=text
    :autocmd BufWinLeave * set noscrollbind
	:normal <Ctrl+w>w
    :syncbind
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

"map <C-S-l>  :vertical res +3<cr>
"map <C-S-h>  :vertical res -3<cr>
"map <C-S-k>  :res +2<cr>
"map <C-S-j>  :res -2<cr>

" increment value shortcut 
nnoremap <C-b> <C-a>

map <C-F1> :b1<CR>
map <F2> :Explore<CR>

map <F3> :b1<CR>

map <A-F4> :q<CR>
"map <F4> :call OMakeGitDiffView() <CR>
map <F4> :GFiles?<CR>

map <F5> :!otags<CR> :cscope reset <CR>

map <F6> :buffers<CR>:e #

" quickfix shortcuts
map <F7> :cf .errfile.tmp<CR>
map <S-F7> :cl<CR>
map <C-F7> :cn<CR>
map <C-S-F7> :cp<CR>


map <S-F9> :setlocal spell! spelllang=en_us<CR>
imap <S-F9> <C-o>:setlocal spell! spelllang=en_us<CR>
set pastetoggle=<F9>

map <S-Left> :bp<CR>
map <S-Right> :bn<CR>

nmap <C-P> :Files<CR>
nmap <F8> :call OGrep() <CR> 

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
"  COLORS and FONTS
" ***************************************
syntax enable
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
map <F5> :set diffopt^=iwhite<CR>
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
"

" cscope
if has("cscope")

"set nocscopetag

function! Cscope(option, query)
  " set color for path and code line
  let color = 'print("\x1b[38;5;95m$F[0] $F[2] ->  \x1b[38;5;2m@F[3..$#F]\n")'
  " set color for highlighted line in code preview
  let preview = 'print("\x1b[38;5;2m$_\x1b[0m") if $. == $line; print "$_" if $. != $line'

  let opts = {
  \ 'source':  "cscope -dL" . a:option . " " . a:query . " | perl -nae '" . color . "'",
  \ 'options': ['--ansi', '--prompt', '> ',
  \             '--multi', '--bind', 'ctrl-j:down,ctrl-k:up',
  \             '--preview', "cat {1} | perl -ne '$line={2}; " . preview . "'",
  \             '--preview-window', '+{2}-10'],
  \ 'down': '70%'
  \ }
  "\             '--color', 'fg:236,fg+:222,bg+:#3a3a3a,hl+:104',

  function! opts.sink(lines) 
    let data = split(a:lines)
    execute 'e ' . '+' . data[1] . ' ' . data[0]
  endfunction
  call fzf#run(opts)
endfunction

function! CscopeAllSyms()
    " FIXME broken right now
  let color = 'print("\x1b[38;5;13m$F[0] $F[2] ->  \x1b[38;5;7m@F[3..$#F]\n")'
  let preview = 'print("\x1b[38;5;76m$_\x1b[0m") if $. == $line; print "$_" if $. != $line'

  let opts = {
  \ 'source':  "cscope -dL" . a:option . " " . a:query . " | perl -nae '" . color . "'",
  \ 'options': ['--ansi', '--prompt', '> ',
  \             '--multi', '--bind', 'ctrl-j:down,ctrl-k:up',
  \             '--color', 'fg:188,fg+:222,bg+:#3a3a3a,hl+:104',
  \             '--preview', "cat {1} | perl -ne '$line={2}; " . preview . "'",
  \             '--preview-window', '+{2}-10'],
  \ 'down': '70%'
  \ }
  function! opts.sink(lines) 
    let data = split(a:lines)
    execute 'e ' . '+' . data[1] . ' ' . data[0]
  endfunction
  call fzf#run(opts)
endfunction


function! CscopeQuery(option)
  call inputsave()
  if a:option == '0'
    let query = input('Find C symbol: ')
  elseif a:option == '1'
    let query = input('Find definition: ')
  elseif a:option == '2'
    let query = input('???: ')
  elseif a:option == '3'
    let query = input('???: ')
  elseif a:option == '4'
    let query = input('???: ')
  elseif a:option == '6'
    let query = input('Egrep: ')
  elseif a:option == '7'
    let query = input('Find file: ')
  elseif a:option == '8'
    let query = input('Find files #including this file: ')
  elseif a:option == '9'
    let query = input('Assignments to: ')
  elseif a:option == '10'
    let query = input('Number of commits back: ')
    "execute 'enew | set bt=nofile | r !git log --oneline --name-only --stat=100 -' . query
    execute 'enew | set bt=nofile | r !git diff --name-only --stat HEAD~' . query
    return
  else
    echo "Invalid option!"
    return
  endif
  call inputrestore()
  if query != ""
    call Cscope(a:option, query)
  else
    echom "Cancelled Search!"
  endif
endfunction


" 0: Find this C symbol
nnoremap <silent> <Leader>cs :call Cscope('0', expand('<cword>'))<CR>
nmap <C-\>s :call Cscope('0', expand('<cword>'))<CR>
nnoremap <silent> <Leader><Leader>cs :call CscopeQuery('0')<CR>

" 1: Find this definition
nnoremap <silent> <Leader>cg :call Cscope('1', expand('<cword>'))<CR>
nmap <C-\>g :call Cscope('1', expand('<cword>'))<CR>
nnoremap <silent> <Leader><Leader>cg :call CscopeQuery('1')<CR>

" 2: Find functions called by this function
"nnoremap <silent> <Leader>cd :call Cscope('2', expand('<cword>'))<CR>
"nnoremap <silent> <Leader><Leader>cd :call CscopeQuery('2')<CR>

" 3: Find functions calling this function
"nnoremap <silent> <Leader>cc :call Cscope('3', expand('<cword>'))<CR>
"nmap <C-\>c :call Cscope('3', expand('<cword>'))<CR>
"nnoremap <silent> <Leader><Leader>cc :call CscopeQuery('3')<CR>

" 4: Find this text string
"nnoremap <silent> <Leader>cf :call Cscope('4', expand('<cword>'))<CR>

" 5: Find any symbol
nnoremap <silent> <Leader><Leader>ca :call CscopeAllSyms()<CR>

" 6: Find this egrep pattern
nnoremap <silent> <Leader>ce :call Cscope('6', expand('<cword>'))<CR>
nmap <C-\>e :call Cscope('6', expand('<cword>'))<CR>
nnoremap <silent> <Leader><Leader>ce :call CscopeQuery('6')<CR>

" 7: Find this file
nnoremap <silent> <Leader>cf :call Cscope('7', expand('<cfile>'))<CR>
nmap <C-\>f :call Cscope('7', expand('<cfile>'))<CR>
nnoremap <silent> <Leader><Leader>cf :call CscopeQuery('7')<CR>

" 8: Find files #including this file
nnoremap <silent> <Leader>ci :call Cscope('8', expand('%:t'))<CR>
nmap <C-\>i :call Cscope('8', expand('%:t'))<CR>
nnoremap <silent> <Leader><Leader>ci :call CscopeQuery('8')<CR>

" 9: Find places where this symbol is assigned a value
nnoremap <silent> <Leader>ct :call Cscope('9', expand('<cword>'))<CR>
nmap <C-\>t :call Cscope('9', expand('<cword>'))<CR>
nnoremap <silent> <Leader><Leader>ct :call CscopeQuery('9')<CR>

" 10: Find files changed in recent commits
nnoremap <silent> <Leader><Leader>g :call CscopeQuery('10')<CR>
nnoremap <silent> <Leader>gb :call OGitBlame(expand('%'))<CR>

endif " cscope
