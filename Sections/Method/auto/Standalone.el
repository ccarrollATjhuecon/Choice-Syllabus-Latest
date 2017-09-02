(TeX-add-style-hook "Standalone"
 (lambda ()
    (TeX-add-symbols
     "si"
     "ac"
     "gk"
     "kh"
     "cp")
    (TeX-run-style-hooks
     "latex2e"
     "bejournal10"
     "bejournal"
     "CDCDocStartForBE"
     "./body"
     "bibMake")))

