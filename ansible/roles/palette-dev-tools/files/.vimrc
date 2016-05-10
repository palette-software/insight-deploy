set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()
" alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'flazz/vim-colorschemes'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

Plugin 'fatih/vim-go'

" call pathogen#infect()
syntax enable
filetype plugin indent on

" Theme
syntax on
colorscheme molokai
"set background=light

" Tabs as spaces
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" Basic settings
set backspace=indent,eol,start
set number
set ruler
set showcmd
set incsearch
set hlsearch
set title

" Enable mouse
set mouse=a

" keep undo between sessions
set undofile
set undodir=/tmp/vimundo/

" Coffeescript
let coffee_indent_keep_current = 1
let coffee_linter = '/usr/local/bin/coffeelint'
let coffee_lint_options = '-f ~/coffeelint.json'
" Tagbar
nmap <c-a> :TagbarToggle<CR>
command Lint CoffeeLint | :botright cwindow

" Auto open
" autocmd vimenter * NERDTree
" autocmd vimenter * TagbarToggle

" NerdTREE
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" C++ header/source switch
" nmap <F4> :e %:p:s,.hh$,.X123X,:s,.cc$,.hh,:s,.X123X$,.cc,<CR>

" OSX clipboard
" set clipboard=unnamedplus,unnamed,autoselect

" Macros for quoting/unquting words
" 'quote' a word
nnoremap qw :silent! normal mpea'<Esc>bi'<Esc>`pl
" double quote a word
nnoremap qd :silent! normal mpea"<Esc>bi"<Esc>`pl
" remove quotes from a word
nnoremap wq :silent! normal mpeld bhd `ph<CR>

" Auto remove trailing whitespaces on save
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd FileType c,cpp,java,php,ruby,python,js,coffee autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()


" ======= blig/vim-airline settings =====
" Always show the status bar
set laststatus=2

" Show PASTE if in paste mode
let g:airline_detect_paste=1

" Show airline for tabs too
let g:airline#extensions#tabline#enabled = 1

" ----- scrooloose/syntastic settings -----
"let g:syntastic_error_symbol = '✘'
"let g:syntastic_warning_symbol = "▲"
"augroup mySyntastic
"  au!
"  au FileType tex let b:syntastic_mode = "passive"
"augroup END

" FuzzyFinder keybindings
"function! OpenFile()
"    if stridx(bufname("%"),"NERD_tree") >= 0
"       :wincmd w
"    endif
    ":FufFile
"endfunction
"noremap <silent> <c-p> :call OpenFile()<CR>
"function! OpenBuffer()
    "if stridx(bufname("%"),"NERD_tree") >= 0
       ":wincmd w
    "endif
    ":FufBuffer
"endfunction
"noremap <silent> <D-b> :call OpenBuffer()<CR>

" coffeescript textobjects indent stuff
" See http://andrewradev.com/2012/04/03/manipulating-coffeescript-with-vim-part-1-text-objects/
" for details on the implementation

onoremap ii :<c-u>call <SID>IndentTextObject()<cr>
onoremap аi :<c-u>call <SID>IndentTextObject()<cr>
xnoremap ii :<c-u>call <SID>IndentTextObject()<cr>
xnoremap ai :<c-u>call <SID>IndentTextObject()<cr>
function! s:IndentTextObject()
  let upper = s:UpperIndentLimit(line('.'))
  let lower = s:LowerIndentLimit(line('.'))
  call s:MarkVisual('V', upper, lower)
endfunction

onoremap if :<c-u>call <SID>FunctionTextObject('i')<cr>
onoremap af :<c-u>call <SID>FunctionTextObject('a')<cr>
xnoremap if :<c-u>call <SID>FunctionTextObject('i')<cr>
xnoremap af :<c-u>call <SID>FunctionTextObject('a')<cr>
function! s:FunctionTextObject(type)
  let function_start = search('\((.\{-})\)\=\s*[-=]>$', 'Wbc')
  if function_start <= 0
    return
  endif

  let body_start = function_start + 1
  if body_start > line('$') || indent(nextnonblank(body_start)) <= indent(function_start)
    if a:type == 'a'
      normal! vg_
    endif

    return
  endif

  let indent_limit = s:LowerIndentLimit(body_start)

  if a:type == 'i'
    let start = body_start
  else
    let start = function_start
  endif

  call s:MarkVisual('v', start, indent_limit)
endfunction

function! s:LowerIndentLimit(lineno)
  let base_indent  = indent(a:lineno)
  let current_line = a:lineno
  let next_line    = nextnonblank(current_line + 1)

  while current_line < line('$') && indent(next_line) >= base_indent
    let current_line = next_line
    let next_line    = nextnonblank(current_line + 1)
  endwhile

  return current_line
endfunction

function! s:UpperIndentLimit(lineno)
  let base_indent  = indent(a:lineno)
  let current_line = a:lineno
  let prev_line    = prevnonblank(current_line - 1)

  while current_line > 0 && indent(prev_line) >= base_indent
    let current_line = prev_line
    let prev_line    = prevnonblank(current_line - 1)
  endwhile

  return current_line
endfunction

function! s:MarkVisual(command, start_line, end_line)
  if a:start_line != line('.')
    exe a:start_line
  endif

  if a:end_line > a:start_line
    exe 'normal! '.a:command.(a:end_line - a:start_line).'jg_'
  else
    exe 'normal! '.a:command.'g_'
  endif
endfunction

" :shell
function! s:ExecuteInShell(command)
    let command = join(map(split(a:command), 'expand(v:val)'))
    let winnr = bufwinnr('^' . command . '$')
    silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
    echo 'Execute ' . command . '...'
    silent! execute 'silent %!'. command
    silent! execute 'resize ' . 10
    silent! execute '$'
    silent! redraw
    silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
    silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
    echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)

" auto run npm test
" autocmd BufWritePost *.coffee Shell npm test
"
" GO Lang
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>e <Plug>(go-rename)


