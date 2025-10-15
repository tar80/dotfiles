function s:ignore_indent() abort
  if expand("%:e") == "md"
    return
  endif
  setlocal formatoptions-=r
  setlocal formatoptions-=o
endfunction

au BufReadPost * call <SID>ignore_indent()
