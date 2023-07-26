cnoreabbrev Target CMakeSelectTarget
cnoreabbrev Tgt FZFCMakeSelectTarget
let g:cmake_build_type = 'Debug'
let g:cmake_compile_commands = 1
let g:cmake_compile_commands = 1
let g:cmake_compile_commands_link = './build/compile_commands.json'
let g:cmake_project_generator = 'Ninja'
let g:cmake_vimspector_support = 1
let g:cmake_build_path_pattern = [ "build/%s", "g:cmake_build_type" ]
let g:cmake_vimspector_default_configuration = {
            \ 'adapter': 'vscode-cpptools',
            \ 'configuration': {
                \ 'request': 'launch',
                \ 'cwd': '${workspaceRoot}',
                \ 'MIMode': 'gdb',
                \ 'setupCommands': [
                \     {
                \         'description': 'Enable pretty-printing for gdb',
                \         'text': '-enable-pretty-printing'
                \     }
                \ ],
                \ 'args': [],
                \ 'program': ''
                \ }
            \ }

