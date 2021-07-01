;;; abbrev.el -*- coding: utf-8; lexical-binding: t; -*-

(clear-abbrev-table global-abbrev-table)

(define-abbrev-table 'global-abbrev-table
  '(("btw" "by the way")
    ("atm" "at the moment" )
    ("ty" "thank you")
    ("uno" "✗")
    ("uok" "✓")
    ("ura" "→" )
    ("altough" "although")
    ("widht" "width")
    ("thougth" "thought")
    ("tought" "thought")
    ("lenght" "length")
    ("strenght" "strength")
    ("weigth" "weight")
    ("wether" "whether")
    ("recieve" "receive")))

(define-abbrev-table 'prog-mode-abbrev-table
  '(("rt" "return")
    ("ud" "undefined")))

(define-abbrev-table 'sh-mode-abbrev-table
  '(("shb" "#!/usr/bin/env bash\n")
    ("ec" "echo")
    ("pf" "printf")))

(define-abbrev-table 'python-mode-abbrev-table
  '(("shb" "#!/usr/bin/env python\n")
    ("ffi" "from flask import")
    ("pr" "print")
    ("cl" "class")
    ("ifn" "if __name__ == \"__main__\":\n    ")
    ("pdb" "import pdb; pdb.set_trace()  # debug")))

(set-default 'abbrev-mode t)

(setq save-abbrevs nil)
