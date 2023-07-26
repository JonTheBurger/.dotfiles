""" Remove all trailing whitespace from file
function! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction
command! TrimWhitespace call TrimWhitespace()

