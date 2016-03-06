;; Enabling color themes
(setq custom-theme-directory "~/.emacs.d/themes")
(setq custom-safe-themes t)
(load-theme 'blackboard)

;; Chrome
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(fringe-mode 0)

(require 'package)
(add-to-list 'package-archives 
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;; (require 'multiple-cursors)

;; Powerline
(add-to-list 'load-path "~/.emacs.d/vendor/emacs-powerline")
(require 'powerline)
;; (set-face-attribute 'mode-line nil
;;                     :foreground "Black"
;;                     :background "DarkOrange"
;;                     :box nil)
;; (setq powerline-arrow-shape 'diagonal)
;; (setq-default mode-line-format '("%e"
;;   (:eval
;;    (concat
;;     (powerline-rmw 'left nil)
;;     (powerline-buffer-id 'left nil powerline-color1)
;;     (powerline-minor-modes 'left powerline-color1)
;;     (powerline-narrow 'left powerline-color1 powerline-color2)
;;     (powerline-vc 'center powerline-color2)
;;     (powerline-make-fill powerline-color2)
;;     (powerline-row 'right powerline-color1 powerline-color2)
;;     (powerline-make-text ":" powerline-color1)
;;     (powerline-column 'right powerline-color1)
;;     (powerline-percent 'right nil powerline-color1)
;;     (powerline-make-text "  " nil)))))

;; scroll one line at a time (less "jumpy" than defaults)
    
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
;; (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; Disable ring bell when scrolling
(defun my-bell-function ()
  (unless (memq this-command
        '(isearch-abort abort-recursive-edit exit-minibuffer
              keyboard-quit mwheel-scroll down up next-line previous-line
              backward-char forward-char))
    (ding)))
(setq ring-bell-function 'my-bell-function)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#0C1021" :foreground "#F8F8F8" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "nil" :family "DejaVu Sans Mono")))))
