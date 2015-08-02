To Use:
Copy this folder to  Pathogen bundle folder.

Put sample.pyprj in top of your project folder:
---------------------------------------------
# sample.pyprj
README
plugin/pyproject.vim
# Customize as need... 
---------------------------------------------

Open sample.pyprj and issue the vim command
:PyOpenProject
And voila, all files are open!

---------------------------------------------
Merits of this plugin:
Simple config file to open all project files
Very very simple Python code, customize it as you need ...

Demerits:
Only tested with MacVim
Not suitable for very large project, in this case is better to use "git grep" /C-Scope / GNU ID Utils ...

Dependencies:
Vim compiled with Python
BufOnly plugin
