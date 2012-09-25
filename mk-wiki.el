; Emacs setup for using wikipedia-mode.el
; 

(autoload 'wikipedia-mode "wikipedia-mode.el"
"Major mode for editing documents in Wikipedia markup." t)

(add-to-list 'auto-mode-alist
'("\\.wiki\\'" . wikipedia-mode))

(add-to-list 'auto-mode-alist
'("itsalltext.*\\.txt$" . wikipedia-mode))



