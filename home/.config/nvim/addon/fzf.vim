let $FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git"'
:map <C-P> :FZF<CR>

" command! -bang -nargs=? -complete=dir PFiles
"       \ call fzf#vim#grep(<q-args>, {'options': ['--hidden', '-g', '!.git']}, <bang>0)
" :map <C-p> :PFiles<CR>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case --sort path --hidden -g "!.git" -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
:map <C-K> :RG<CR>
" :map <C-S-k> :Rg<CR>

