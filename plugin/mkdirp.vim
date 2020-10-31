" File:        plugin/mkdirp.vim
" Description: Automatically make parent dirs when writing.
" Author:      Randy Stauner
" Source:      https://github.com/rwstauner/vim-write-plus
" License:     Same terms as Vim itself (see :help license).

if exists('g:loaded_write_plus_mkdirp')
  finish
endif

if !exists('g:write_plus_mkdirp_new_files_only')
  let g:write_plus_mkdirp_new_files_only = 1
endif

augroup WritePlusMkdirP
  autocmd!
  if g:write_plus_mkdirp_new_files_only
    autocmd BufNewFile  * let b:write_plus_mkdirp = 1
    autocmd BufWritePre * if exists("b:write_plus_mkdirp") | call s:AutoMkdirP() | endif
  else
    autocmd BufWritePre * call s:AutoMkdirP()
  endif
augroup END

function! s:AutoMkdirP()
  let l:file = expand("<afile>")
  if !exists("b:write_plus_mkdirp_done")
    call MakeParents(l:file)
    let b:write_plus_mkdirp_done = 1
  endif
endfunction

function! MakeParents(file)
  let l:dir = fnamemodify(a:file, ':h')
  if !isdirectory(l:dir)
    call mkdir(l:dir, 'p')
  endif
endfunction

let g:loaded_write_plus_mkdirp = 1
