;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mk-tex.el
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Specific code to load in everything needed for auctex
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Install AUCTEX system wide.  
;; - There is an ubuntu package for AUCTEX, no need to handle the 
;;   source of this.  Ubuntu package ensures other pre-requisites 
;;   are handled.
;(add-to-list 'load-path "~/.emacs.d/vendor/auctex")

;(load "auctex.el" nil t t)
;(load "preview-latex.el" nil t t)

(require 'preview-latex)
(setq TeX-auto-save t)
(setq TeX-parse-self t)

