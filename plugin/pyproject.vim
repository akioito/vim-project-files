" File: pyproject.vim
" Author: Akio Ito
" Version: 0.7
" Last Modified: Jun 25 2020
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
" 1. Only tested with MacVim 
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
if !exists("g:currProject")
    return
endif
let s:path = expand('<sfile>:p:h')
Py << EOF
import vim 
import os
from glob import glob
from os.path import abspath, basename

currentProject = vim.eval("g:currProject").replace(' ','\\ ')
vim.command("silent edit %s" % currentProject)
vim.command("silent BufOnly")
cwdir = vim.eval('s:path')
cwdir = cwdir.replace(' ','\\ ')
os.chdir(cwdir)

files_list = []
vim_command = []
for line in vim.current.buffer[:]: 
    if line and not line.startswith('#'):
        files_list += glob(line)
    if line and line.find('# cmd:') >= 0:  # Arbitrary vim command  
        vim_command.append(line.split('# cmd:')[1]) 

for xfile in files_list:
    # vim.command("silent badd %s" % abspath(xfile)) # Speedy, but sometimes has problem with japanese char (mojibake) 
    file_path = abspath(xfile)
    vim.command("silent edit %s" % file_path)
    vim.command('echon "%s"' % file_path)
    vim.chdir(cwdir)
    
# vim.command("brewind")
# vim.command("bufdo bnext")
vim.command("syntax enable")
vim.command("buffer %s" % basename(xfile)) 

for cmd in vim_command: 
    vim.command(cmd)
EOF
endfunction

command! PyOpenProject call s:OpenProjectFiles()

autocmd BufEnter *.pyprj   let g:currProject = expand('%:p')
autocmd BufEnter *.vim-prj let g:currProject = expand('%:p')
