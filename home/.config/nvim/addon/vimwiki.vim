""" Wiki
" <leader>wi - diary index
" <leader>w<leader>i - update diary index
" <leader>w<leader>w - diary today
  let g:vimwiki_autochdir = 1
  let g:vimwiki_hl_headers = 1
  let g:vimwiki_global_ext = 0
  let g:vimwiki_markdown_link_ext = 1
  let g:vimwiki_folding='expr'
  let g:vimwiki_list = [{ 'path': '~/Documents/wiki/',
    \ 'syntax': 'markdown',
    \ 'ext': '.md',
    \ 'nested_syntaxes': {'python': 'python', 'cpp': 'cpp', 'bash': 'sh' } }]

