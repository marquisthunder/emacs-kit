(color-theme-sanityinc-tomorrow-eighties)
(add-to-list 'load-path "~/.emacs.d/user")
(add-to-list 'load-path "~/.emacs.d/snippets")
(add-to-list 'load-path "~/.emacs.d/elpa/ack-and-a-half")
(require 'ack-and-a-half)
;; Create shorter aliases
(defalias 'ack 'ack-and-a-half)
(defalias 'ack-same 'ack-and-a-half-same)
(defalias 'ack-find-file 'ack-and-a-half-find-file)
(defalias 'ack-find-file-same 'ack-and-a-half-find-file-same)

(global-set-key [(meta return)] 'toggle-fullscreen)
;;disable suspending emacs on ctrl-z
(global-set-key (kbd "C-z") 'undo)
(global-unset-key (kbd "C-x C-z"))
;jump to line
(global-set-key (kbd "C-c M-l") 'goto-line)
;;use ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)
;;use ace-jump-mode
(global-set-key (kbd "C-'") 'ace-jump-mode)
;;use idomenu to search for symbols
(global-set-key (kbd "C-o") 'idomenu)
(global-set-key (kbd "C-x C-d") 'kill-this-buffer) ; Close file
(desktop-save-mode 1)

;;; esc quits
(evil-mode 1)
(global-linum-mode 1)

(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

;;; initial set state mode for some specie modes

;basic colors - comment this out to use light background
;(custom-set-faces
; '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 90 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))

;;auto-complete, ac-slime
(autoload 'set-up-slime-ac "ac-slime")
(autoload 'ac-config-default "auto-complete-config")
(ac-config-default)
(autoload 'slime-repl-mode "slime") 
(add-to-list 'ac-modes 'slime-repl-mode)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)

(add-hook 'coffee-mode-hook '(lambda () (coffee-cos-mode t)))

'(require 'sws-mode)
'(require 'jade-mode)
'(add-to-list 'auto-mode-alist '("\\.styl$" . sws-mode))
'(add-to-list 'auto-mode-alist '("\\.jade$" . jade-mode))

;; More syntax coloring
(defun tweak-clojure-syntax (mode)
  (mapcar (lambda (x) (font-lock-add-keywords mode x))
          '((("#?['`]*(\\|)" . 'clojure-parens))
            (("#?\\^?{\\|}" . 'clojure-braces))
            (("\\[\\|\\]" . 'clojure-brackets))
            ((":\\w+" . 'clojure-keyword))
            (("#?\"" 0 'clojure-double-quote prepend))
            (("nil\\|true\\|false\\|%[1-9]?" . 'clojure-special))
            (("(\\(\\.[^ \n)]*\\|[^ \n)]+\\.\\|new\\)\\([ )\n]\\|$\\)" 1
              'clojure-java-call))
            (("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 'font-lock-warning-face t))
            (("(\\(fn\\>\\)" 0 (progn (compose-region (match-beginning 1)
                                                      (match-end 1) "ƒ") nil)))
            (("(\\(->\\>\\)" 0 (progn (compose-region (match-beginning 1)
                                                      (match-end 1) "→") nil)))
            (("(\\(->>\\>\\)" 0 (progn (compose-region (match-beginning 1)
                                                       (match-end 1) "↠") nil)))
            (("(\\(complement\\>\\)" 0 (progn (compose-region
                                                (match-beginning 1)
                                                (match-end 1) "¬") nil)))
            (("^[a-zA-Z0-9-.*+!_?]+?>" . 'slime-repl-prompt-face)))))

;; Macro for face definition
(defmacro defcljface (name color desc &optional others)
  `(defface ,name '((((class color)) (:foreground ,color ,@others)))
            ,desc :group 'faces))

;; Define extra clojure faces
(defcljface clojure-parens       "DimGrey"   "Clojure parens")
(defcljface clojure-braces       "#49b2c7"   "Clojure braces")
(defcljface clojure-brackets     "#0074e8"   "Clojure brackets")
(defcljface clojure-keyword      "#45b8f2"   "Clojure keywords")
(defcljface clojure-namespace    "#a9937a"   "Clojure namespace")
(defcljface clojure-java-call    "#7587a6"   "Clojure Java calls")
(defcljface clojure-special      "#0074e8"   "Clojure special")
(defcljface clojure-double-quote "#00920A"   "Clojure special")


(autoload 'clojure-mode "clojure-mode")
(add-hook 'slime-repl-mode-hook 'durendal-slime-repl-paredit)
(add-hook 'sldb-mode-hook 'durendal-dim-sldb-font-lock)
(add-hook 'clojure-mode-hook 
          (lambda () 
            (define-key clojure-mode-map (kbd "M-[") 'paredit-wrap-square)
            (define-key clojure-mode-map (kbd "M-{") 'paredit-wrap-curly)))


(autoload 'paredit-wrap-square "paredit")
(add-hook 'slime-connected-hook
          (lambda () 
            (define-key slime-mode-map " " 'slime-space)
            (define-key slime-mode-map (kbd "M-[") 'paredit-wrap-square)
            (define-key slime-mode-map (kbd "M-{") 'paredit-wrap-curly)
            (define-key slime-repl-mode-map [C-S-up] 'slime-repl-previous-matching-input)))

;;clojure-jack-in
(global-set-key (kbd "C-c C-j") 'nrepl-jack-in)

(defun goto-last-edit-point ()
  "Go to the last point where editing occurred."
  (interactive)
  (let ((undos buffer-undo-list))
    (when (listp undos)
      (while (and undos
                  (let ((pos (or (cdr-safe (car undos))
                                 (car undos))))
                    (not (and (integerp pos)
                              (goto-char (abs pos))))))
             (setq undos (cdr undos))))))
(global-set-key (kbd "C-c SPC") 'goto-last-edit-point)

;;browse link shortcut
(global-set-key (kbd "C-c M-b") 'browse-url-at-point)

(defun start-newline-next ()
  (interactive)
  (end-of-line)
  (newline-and-indent))

(defun start-newline-prev ()
  (interactive)
  (forward-line -1)
  (start-newline-next))

(global-set-key (kbd "C-o") 'start-newline-next)
(global-set-key (kbd "M-o") 'start-newline-prev)

;;fullscreen
(defun toggle-fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen)
                                         nil
                                         'fullboth)))

(global-set-key [(meta return)] 'toggle-fullscreen)
(setq window-system-default-frame-alist
      '(
        ;; if frame created on x display
        (x
          (menu-bar-lines . 1)
          (tool-bar-lines . nil)
          ;; mouse
          (mouse-wheel-mode . 1)
          (mouse-wheel-follow-mouse . t)
          (mouse-avoidance-mode . 'exile)
          ;; face
          (font . "文泉驿等宽微米黑 12")
          (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen)
                                         nil
                                         'fullboth))
          )
        ;; if on term
        (nil
          (menu-bar-lines . 0) (tool-bar-lines . 0)
          ;; (background-color . "black")
          ;; (foreground-color . "white")
          (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen)
                                         nil
                                         'fullboth))
          )
        )
      )

(provide 'user)
