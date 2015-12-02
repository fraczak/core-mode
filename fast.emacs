(setq load-path
      (append load-path
              '("/home/wojtek/emacs-files/")))

(require 'iso-transl) ;; or unset XMODIFIERS, i.e., export XMODIFIERS=""
(setq-default indent-tabs-mode nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-PDF-mode t)
 '(TeX-command-BibTeX "Biber")
 '(haskell-literate-default (quote tex))
 '(inhibit-startup-screen t)
 '(ispell-program-name "/usr/bin/ispell")
 '(tool-bar-mode t)
 '(tool-bar-style (quote image))
 '(uniquify-after-kill-buffer-p nil)
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify))
 '(uniquify-min-dir-content 1)
 '(uniquify-strip-common-suffix nil))

(defun enable_flyspell ()
  (ispell-change-dictionary "american")
  (flyspell-prog-mode)
)

;; tuareg-mode
(setq auto-mode-alist (cons '("\\.ml\\w?" . tuareg-mode) auto-mode-alist))

(autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
(autoload 'camldebug "camldebug" "Run the Caml debugger" t)

(if (and (boundp 'window-system) window-system)
    (when (string-match "XEmacs" emacs-version)
      (if (not (and (boundp 'mule-x-win-initted)
                    mule-x-win-initted))
          (require 'sym-lock))
      (require 'font-lock)))
(add-hook
 'tuareg-mode-hook
  '(lambda () (define-key
                tuareg-mode-map "\M-q" 'tuareg-indent-phrase)
     (define-key tuareg-mode-map "\C-c \C-i"
       'caml-types-show-ident)
     (define-key tuareg-mode-map [f4] 'goto-line)
     (define-key tuareg-mode-map [f5] 'compile)
     (define-key tuareg-mode-map [f6] 'recompile)
     (define-key tuareg-mode-map [f7] 'next-error)
     (auto-fill-mode 1)
     (setq tuareg-sym-lock-keywords nil)
     ))

(defadvice LaTeX-fill-region-as-paragraph (around LaTeX-sentence-filling)
  "Start each sentence on a new line."
  (let ((from (ad-get-arg 0))
        (to-marker (set-marker (make-marker) (ad-get-arg 1)))
        tmp-end)
    (while (< from (marker-position to-marker))
      (forward-sentence)
      ;; might have gone beyond to-marker --- use whichever is smaller:
      (ad-set-arg 1 (setq tmp-end (min (point) (marker-position to-marker))))
      ad-do-it
      (ad-set-arg 0 (setq from (point)))
      (unless (or
               (bolp)
               (looking-at "\\s *$"))
        (LaTeX-newline)))
    (set-marker to-marker nil)))
(ad-activate 'LaTeX-fill-region-as-paragraph)

(setq column-number-mode t)
(setq mouse-wheel-follow-mouse t)
(transient-mark-mode 1)
(setq visible-bell t)
(setq show-paren-face 'modeline)
(setq global-font-lock-mode t)
(setq global-auto-revert-mode t)

;; to setup tabs
(setq-default c-basic-indent 4)
(setq-default standard-indent 4)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;; jade-mode
(add-to-list 'load-path "~/gits/jade-mode")
(require 'sws-mode)
(require 'jade-mode)
(add-to-list 'auto-mode-alist '("\\.styl$" . sws-mode))
(add-to-list 'auto-mode-alist '("\\.jade$" . jade-mode))
;;(add-to-list 'auto-mode-alist '("\\.[_]?coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("\\.[_]?js$" . js2-mode))

(global-whitespace-mode)
(setq whitespace-line nil)
(setq whitespace-line-column 120)

(add-to-list 'load-path "~/gits/idle-highlight-mode")
(require 'idle-highlight-mode)
(add-to-list 'load-path "~/gits/core-mode")
(require 'core-mode)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)

;; flymake for JavaScript using JSHint through node-jshint.
;;(add-to-list 'load-path "~/gits/flymake-node-jshint")
;;(require 'flymake-node-jshint)
;; (setq flymake-node-jshint-config "~/.jshintrc-node.json") ; optional
;;(add-hook 'js-mode-hook (lambda () (flymake-mode 1)))
