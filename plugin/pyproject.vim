" File: pyproject.vim
" Author: Akio Ito
" Version: 0.6
" Last Modified: Aug 2 2015
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
"  1.Generate project file, file with .pyprj extension
"   find .. -name '*.*' |egrep '\.py$|\.css$|\.ini$|\.html$'  >myProject.pyprj
"  2.Open generated project
"  3.To open all project files   => :PyOpenProject

" Sample project files
" # node - sample.pyprj
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
Py << EOF
import os
import vim 

currentProject = vim.eval("g:currProject").replace(' ','\\ ')
vim.command("silent edit %s" % currentProject)
vim.command("silent BufOnly")
cwdir = os.getcwd() # relative to g:currProject
cwdir = cwdir.replace(' ','\\ ')

xFiles = []
for line in vim.current.buffer[:]: 
    if line and not line.startswith('#'):
        vim.command("next %s" % line)
        os.chdir(cwdir)
    if line and line.find('# cmd:') >= 0:  # Arbitrary vim command
        vim.command(line.split('# cmd:')[1]) 
print(' ')
EOF
endfunction

command! PyOpenProject call s:OpenProjectFiles()

autocmd BufEnter *.pyprj   let g:currProject = expand('%:p')
autocmd BufEnter *.vim-prj let g:currProject = expand('%:p')
