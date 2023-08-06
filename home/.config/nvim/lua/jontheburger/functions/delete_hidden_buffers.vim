function! DeleteHiddenBuffers()
  redir => buffersoutput
  buffers
  redir END
  let buflist = split(buffersoutput,"\n")
  for item in filter(buflist,"v:val[5] == 'h'")
    exec 'bdelete ' . item[:2]
  endfor
endfunction

command Qaev :call DeleteHiddenBuffers()
