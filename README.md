# Emacs Config

## Installation
Backup your current emacs configuration directory. Afterwards run:
```
git clone git@github.com:w8ste/emacs.git ~/.config/emacs
```

Then open a new emacs instance (not client) and run the following commands with `M-x`:
```
pdf-tools-install
```

## LSP
### LaTeX
An installation guide for  `texlive` can be found ![here](https://www.tug.org/texlive/quickinstall.html).

This is not required for ![texlab](https://github.com/latex-lsp/texlab), but it is recommended so `texlab` can compile your documents.

Installing `texlab`:
```
cargo install --locked --git https://github.com/latex-lsp/texlab.git
```


## Dependencies 
- It is required to have a GUI application set as a pinentry program if you want to be able to sign commits from within emacs. Or atleast i did not get a tty version to work for me, this is probably a skill issue, altough utilizing a program like `pinentry-gtk2` is an easy fix.
- AucTeX

Using emacs because Dr. Kord Eikmeyer advocates for it.


