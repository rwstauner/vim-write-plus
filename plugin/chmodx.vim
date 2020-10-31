" File:        plugin/chmodx.vim
" Description: Automatically set the exec bit when writing.
" Author:      Randy Stauner
" Source:      https://github.com/rwstauner/vim-write-plus
" License:     Same terms as Vim itself (see :help license).

if exists('g:loaded_write_plus_chmodx')
  finish
endif

if !exists('g:write_plus_chmodx_new_files_only')
  let g:write_plus_chmodx_new_files_only = 1
endif

augroup WritePlusChmodX
  autocmd!
  if g:write_plus_chmodx_new_files_only
    autocmd BufNewFile   * let b:write_plus_chmodx = 1
    autocmd BufWritePost * if exists("b:write_plus_chmodx") | call s:AutoChmodX() | endif
  else
    autocmd BufWritePost * call s:AutoChmodX()
  endif
augroup END

function! s:AutoChmodX()
  if !exists("b:write_plus_chmodx_done")
    " if file starts with shebang
    if getline(1) =~ "^#!.*"
      return ChmodX(expand("<afile>"))
      let b:write_plus_chmodx_done = 1
    endif
  endif
  " Leave b:write_plus_chmodx in case the file is saved,
  " and then the shebang is added later before quitting.
endfunction

function! ChmodX(file)
  " Set x for every r.
  let l:mode = substitute(getfperm(a:file), "\\(r.\\).", "\\1x", "g")
  call setfperm(a:file, l:mode)
endfunction

let g:loaded_write_plus_chmodx = 1
