(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-PDF-mode t)
 '(custom-enabled-themes nil)
 '(inhibit-startup-screen t)
 '(tool-bar-style (quote image)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq-default indent-tabs-mode nil)
;;(set-face-attribute 'default nil :height 100)
(setq load-path
      (append load-path
              '("~/emacs-files/")
      )
)

(add-to-list 'load-path "~/gits/multi-web-mode")
(require 'multi-web-mode)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags
      '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
        (js-mode "<script[^>]*>" "</script>")
        (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
(multi-web-global-mode 1)

(add-to-list 'load-path "~/gits/idle-highlight-mode")
(require 'idle-highlight-mode)
(add-to-list 'load-path "~/gits/core-mode")
(require 'core-mode)

;;; turn on syntax highlighting
(global-font-lock-mode 1)

;;; jade-mode
(add-to-list 'load-path "~/gits/jade-mode")
(require 'sws-mode)
(require 'jade-mode)
(add-to-list 'auto-mode-alist '("\\.styl$" . sws-mode))
(add-to-list 'auto-mode-alist '("\\.jade$" . jade-mode))

(add-to-list 'auto-mode-alist '("\\._coffee$" . coffee-mode))

;; ocaml
(setq auto-mode-alist
      (cons '("\\.ml[iylp]?$" . caml-mode) auto-mode-alist))
(autoload 'caml-mode "caml" "Major mode for editing Caml code." t)
(autoload 'run-caml "inf-caml" "Run an inferior Caml process." t)


(put 'upcase-region 'disabled nil)

(setq default-tab-width 4)
(setq c-basic-offset 4)

;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.


(global-whitespace-mode)
(setq whitespace-line nil)
(setq whitespace-line-column 120)

(require 'iso-transl) 

(add-hook
 'tuareg-mode-hook
 '(lambda·()·(define-key
               tuareg-mode-map·"\M-q"·'tuareg-indent-phrase)
          (define-key·tuareg-mode-map·"\C-c·\C-i"
            'caml-types-show-ident)
          (define-key·tuareg-mode-map·[f4]·'goto-line)
          (define-key·tuareg-mode-map·[f5]·'compile)
          (define-key·tuareg-mode-map·[f6]·'recompile)
          (define-key·tuareg-mode-map·[f7]·'next-error)
          (auto-fill-mode·1)
          (setq·tuareg-sym-lock-keywords·nil)
          ))

(defun my-fill-latex-paragraph ()
  "Fill the current paragraph, separating sentences w/ a newline.

AUCTeX's latex.el reimplements the fill functions and is *very*
convoluted. We use part of it --- skip comment par we are in."
  (interactive)
  (if (save-excursion
        (beginning-of-line) (looking-at TeX-comment-start-regexp))
      (TeX-comment-forward)
  (let ((to (progn
              (LaTeX-forward-paragraph)
              (point)))
        (from (progn
                (LaTeX-backward-paragraph)
                (point)))
        (to-marker (make-marker)))
    (set-marker to-marker to)
    (while (< from (marker-position to-marker))
      (forward-sentence)
      (setq tmp-end (point))
      (LaTeX-fill-region-as-paragraph from tmp-end)
      (setq from (point))
      (unless (bolp)
        (LaTeX-newline))))))

(eval-after-load "latex"
  '(define-key LaTeX-mode-map (kbd "C-M-q") 'my-fill-latex-paragraph))

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
(put 'downcase-region 'disabled nil)
