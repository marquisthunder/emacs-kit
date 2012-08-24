(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages '(color-theme-sanityinc-tomorrow starter-kit starter-kit-lisp starter-kit-eshell starter-kit-js starter-kit-bindings nrepl
                                 org org2blog clojure-mode durendal ac-slime ace-jump-mode idomenu)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;;this works in some emacs setups but not others, don't know why
;; (add-hook 'slime-repl-mode-hook
;;           (defun clojure-mode-slime-font-lock ()
;;             (let (font-lock-mode)
;;               (clojure-mode-font-lock-setup))))
;;this one is uglier but works
(add-hook 'slime-repl-mode-hook 
          (lambda ()
            (font-lock-mode nil)
            (clojure-mode-font-lock-setup)
            (font-lock-mode t)))

(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode 1)))

(custom-set-variables
 '(menu-bar-mode t))

(add-to-list 'load-path "~/.emacs.d")
(require 'user)
