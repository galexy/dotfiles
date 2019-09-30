;;; config.el -- Spacemacs layer configuration
;; Configure spacemacs themes to make org mode more productive and pretty
;; Inspired by https://lepisma.xyz/2017/10/28/ricing-org-mode/
;; Code from https://github.com/lepisma/rogue

(defmacro set-pair-faces (themes consts faces-alist)
  "Macro for pair setting of custom faces.
THEMES name the pair (theme-one theme-two). CONSTS sets the variables like
  ((sans-font \"Some Sans Font\") ...). FACES-ALIST has the actual faces
like:
  ((face1 theme-one-attr theme-two-atrr)
   (face2 theme-one-attr nil           )
   (face3 nil            theme-two-attr)
   ...)"
  (defmacro get-proper-faces ()
    `(let* (,@consts)
       (backquote ,faces-alist)))

  `(setq theming-modifications
         ',(mapcar (lambda (theme)
                     `(,theme ,@(cl-remove-if
                                 (lambda (x) (equal x "NA"))
                                 (mapcar (lambda (face)
                                           (let ((face-name (car face))
                                                 (face-attrs (nth (cl-position theme themes) (cdr face))))
                                             (if face-attrs
                                                 `(,face-name ,@face-attrs)
                                               "NA"))) (get-proper-faces)))))
                   themes)))

(add-hook 'org-mode-hook (lambda () (hl-todo-mode -1) nil))

(set-pair-faces

 ;; Themes to cycle in
 (spacemacs-light doom-one)

 ;; Variables
 ((bg-white           "#fbf8ef")
  (bg-light           "#222425")
  (bg-dark            "#2d343f")
  (bg-darker          "#1c1c1c")
  (fg-white           "#ffffff")
  (shade-white        "#efeae9")
  (fg-light           "#655370")
  (dark-cyan          "#008b8b")
  (region-dark        "#2d2e2e")
  (region             "#39393d")
  (slate              "#8FA1B3")
  (keyword            "#5D80AE")
  (comment            "#525254")
  (builtin            "#fd971f")
  (purple             "#9c91e4")
  (doc                "#727280")
  (type               "#66d9ef")
  (string             "#b6e63e")
  (gray-dark          "#999")
  (gray               "#bbb")
  (sans-font          "Source Sans Pro")
  (serif-font         "Merriweather")
  (et-font            "EtBembo")
  (sans-mono-font     "Roboto Mono")
  (serif-mono-font    "Verily Serif Mono"))

 ;; Settings
 ((variable-pitch
   (:family ,et-font
            :background nil
            :foreground ,bg-dark
            :height 1.25)
   nil)

  (org-document-info
   (:height 1.2
            :slant italic)
   (:foreground ,gray
                :slant italic))

  (org-document-title
   (:inherit nil
             :family ,et-font
             :height 1.8
             :foreground ,bg-dark
             :underline nil)
   (:family ,et-font
            :height 1.5
            :underline t))

  (org-level-1
   (:inherit nil
             :family ,et-font
             :height 1.6
             :weight normal
             :slant normal
             :foreground ,bg-dark)
   (:weight extra-bold
            :underline t))

  (org-level-2
   (:inherit nil
             :family ,et-font
             :weight normal
             :height 1.3
             :slant italic
             :foreground ,bg-dark)
   (:weight bold))

  (org-level-3
   (:inherit nil
             :family ,et-font
             :weight normal
             :slant italic
             :height 1.2
             :foreground ,bg-dark))

  (org-level-4
   (:inherit nil
             :family ,et-font
             :weight normal
             :slant italic
             :height 1.1
             :foreground ,bg-dark))

  ;; (org-level-5
  ;;  nil)
  ;; (org-level-6
  ;;  nil)
  ;; (org-level-7
  ;;  nil)
  ;; (org-level-8
  ;;  nil)

  (org-done
   nil
   (:weight normal))

  (org-headline-done
   (:family ,et-font
            :strike-through t)
   (:strike-through t))

  (org-quote
   (:inherit nil
             :family ,et-font
             :weight normal
             :slant italic
             :height 1.0))

  (org-block-begin-line
   (:background nil
                :height 0.7
                :family ,sans-mono-font
                :foreground ,slate))

  (org-block
   (:background nil
                :height 0.7
                :family ,sans-mono-font
                :foreground ,bg-dark))

  (org-block-end-line
   (:background nil
                :height 0.7
                :family ,sans-mono-font
                :foreground ,slate))

  (org-document-info-keyword
   (:height 0.8
            :foreground ,gray))

  (org-meta-line
   (:height 0.5
            :foreground ,gray-dark))

  (org-link
   (:foreground ,bg-dark)
   (:foreground ,dark-cyan
                :underline t))

  (org-special-keyword
   (:family ,sans-mono-font
            :height 0.8))

  (org-todo
   nil)

  (org-agenda-current-time
   nil)

  (org-hide
   (:foreground ,bg-white))

  (org-indent
   (:inherit (org-hide fixed-pitch)))

  (org-time-grid
   nil)

  (org-warning
   nil)

  (org-date
   (:family ,sans-mono-font
            :height 0.8))

  (org-agenda-structure
   nil)

  (org-agenda-date
   (:inherit variable-pitch
             :height 1.1))

  (org-agenda-date-today
   nil)

  (org-agenda-date-weekend
   nil)

  (org-scheduled
   nil)

  (org-upcoming-deadline
   nil)

  (org-scheduled-today
   nil)

  (org-scheduled-previously
   nil)

  (org-agenda-done
   (:strike-through t
                    :foreground ,doc))

  (org-ellipsis
   (:underline nil
               :foreground ,comment))

  (org-tag
   (:Foreground ,doc))

  (org-table
   (:family ,serif-mono-font
            :height 0.9
            :background ,bg-white))

  (org-code
   (:inherit nil
             :family ,sans-mono-font
             :foreground ,keyword
             :height 0.9))))
