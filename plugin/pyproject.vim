" File: pyproject.vim
" Author: Akio Ito
" Version: 0.20
" Last Modified: sept 23 2023
"
"-----------------------------------------------------------------------------
if has("python3")
    command! -nargs=1 Py py3 <args>
else
    command! -nargs=1 Py py <args>
endif
if !(has('python') || has('python3'))
    echo "Error: Required vim compiled with +python"
    finish
endif
if exists("loaded_pyproject")
    finish
endif
let loaded_pyproject = 1

" Dependency
" 1. Tested with MacVim, Vimr, Neovide, nvim, vim 
" 2. BufOnly plugin
"
" How to use:
"  1.Generate project file, file with .vim-prj extension
"   find .. -name '*.*' |egrep '\.py$|\.css$|\.ini$|\.html$' > myProject.vim-prj
"  2.Open generated project
"  3.To open all project files
"    :PyOpenProject

" Sample project files
" # node - myProject.vim-prj
" *.js
" routes/*.js
" public/*.html
" public/js/*.js
" # cmd: bdelete app.ugly.js
" public/css/*.css
" # cmd: set tags=tags,/Volumes/test/var/www/p/tags

"-----------------------------------------------------------------------------
function! s:OpenProjectFiles()
Py << EOF
import vim
import os
from glob import glob
from os.path import abspath, basename

vim.command("silent BufOnly")
vim.command("silent! :lcd %:p:h")
files_list = []
vim_command = []
for line in vim.current.buffer[:]:
    if line and not line.startswith('#'):
        files_list += glob(line)
    if line and line.find('# cmd:') >= 0:  # Arbitrary vim command
        vim_command.append(line.split('# cmd:')[1])

for xfile in files_list:
    if '.min.' not in xfile:
        vim.command("silent badd %s" % abspath(xfile))

vim.command("silent buffer %s" % basename(xfile))

for cmd in vim_command:
    vim.command(cmd)
EOF
endfunction

command! PyOpenProject call s:OpenProjectFiles()

