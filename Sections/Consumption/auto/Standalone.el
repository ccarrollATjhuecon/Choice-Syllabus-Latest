(TeX-add-style-hook
 "Standalone"
 (lambda ()
   (TeX-run-style-hooks
    "latex2e"
    "./title"
    "./body"
    "econtexBibMake"
    "econtex"
    "econtex10"
    "econtexSetup"
    "econtexShortcuts")))

