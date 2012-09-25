;; Auto-pairing. Hopefully this works better than electric pairs
(require 'autopair)
(autopair-global-mode)

(add-hook 'python-mode-hook
          #'(lambda ()
              (setq autopair-handle-action-fns
                    (list #'autopair-default-handle-action
                          #'autopair-python-triple-quote-action))))
