(setq gc-cons-threshold (* 50 1000 1000))

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                     (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

  ;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Disable backup files.
    (setq make-backup-files nil)
    ;; Prompt to delete autosaves when killing buffers.
    (setq kill-buffer-delete-auto-save-files t)

    (global-visual-line-mode 0)
    (toggle-truncate-lines 0)
    (setq inhibit-splash-screen t)
;(setq warning-minimum-level :error)  ; Only show errors, not warnings
;(setq warning-suppress-types '((comp)))  ; Suppress all compilation warnings

;; magit
  (keymap-global-set "C-c g" 'magit)

  ;; eshell
  (keymap-global-set "C-c e" 'eshell)

  ;; buffer
(which-key-add-key-based-replacements
"C-c b" "buffer")

(keymap-global-set "C-c b i" 'ibuffer)
(keymap-global-set "C-c b p" 'previous-buffer)
(keymap-global-set "C-c b n" 'next-buffer)


;; Text scale
(keymap-global-set "C-c s i" 'text-scale-increase)
(keymap-global-set "C-c s d" 'text-scale-decrease)

;; compile
(keymap-global-set "C-c c" 'compile)

(use-package diminish)
(diminish 'projectile-mode)

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))
(add-hook 'dired-mode-hook 'dired-omit-mode)

(use-package auctex
  :mode ("\\.tex\\'" . LaTeX-mode)
  :hook ((LaTeX-mode . TeX-PDF-mode)
         (LaTeX-mode . TeX-source-correlate-mode)
         (LaTeX-mode . (lambda ()
                         (setq TeX-source-correlate-start-server t)
                         (add-to-list 'TeX-view-program-selection
                                      '(output-pdf "MySplitViewer")))))
  :config
  ;; Register the custom viewer
  (setq TeX-view-program-list
        '(("MySplitViewer" my/TeX-view-split-window)))

  ;; Function to open PDF in a horizontal split using DocView
  (defun my/TeX-view-split-window ()
    (interactive)
    (let* ((pdf-file (concat (TeX-active-master) ".pdf"))
           (pdf-buffer (get-file-buffer pdf-file)))
      (if pdf-buffer
          (progn
            (select-window (split-window-right))
            (switch-to-buffer pdf-buffer))

        (select-window (split-window-right))
        (find-file pdf-file))))
  )

    ;; Make sure this path matches the one installed via cargo
     (setenv "PATH" (concat "/usr/local/texlive/2025/bin/x86_64-linux:" (getenv "PATH")))
     (add-to-list 'exec-path "/usr/local/texlive/2025/bin/x86_64-linux")

(use-package smartparens
  :init
  (smartparens-global-mode))

(use-package move-text
:ensure t
:config
(move-text-default-bindings))  ;; binds M-↑ and M-↓

(use-package dired-open
  :config
  (setq dired-open-extensions '(("gif" . "sxiv")
                                ("jpg" . "sxiv")
                                ("png" . "sxiv")
                                ("mkv" . "mpv")
                                ("mp4" . "mpv"))))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (setq flycheck-display-errors-function
    #'flycheck-display-error-messages-unless-error-list)

  (setq flycheck-indication-mode nil))

(use-package flycheck-pos-tip
  :ensure t
  :after flycheck
  :config
  (flycheck-pos-tip-mode))

(set-frame-font "JetBrains Mono Medium 19")
(set-face-attribute 'default nil
                    :font "JetBrains Mono Medium"
                    :height 110
                    :weight 'medium)
(set-face-attribute 'variable-pitch nil
                    :font "JetBrains Mono Medium"
                    :height 120
                    :weight 'medium)
(set-face-attribute 'fixed-pitch nil
                    :font "JetBrains Mono Medium"
                    :height 110
                    :weight 'medium)
;; Makes commented text and keywords italics.
;; This is working in emacsclient but not emacs.
;; Your font must have an italic face available.
(set-face-attribute 'font-lock-comment-face nil
                    :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil
                    :slant 'italic)

;; This sets the default font on all graphical frames created after restarting Emacs.
;; Does the same thing as 'set-face-attribute default' above, but emacsclient fonts
;; are not right unless I also add this method of setting the default font.
(add-to-list 'default-frame-alist '(font . "JetBrains Mono Medium 12"))

;; Uncomment the following line if line spacing needs adjusting.
(setq-default line-spacing 0.12)

(use-package magit
  :diminish)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(global-visual-line-mode t)

(use-package gradle-mode)

;;(use-package highlight-indent-guides
;;:config
;;(set-face-background 'highlight-indent-guides-odd-face "darkgray")
;;(set-face-background 'highlight-indent-guides-even-face "dimgray")
;;(set-face-foreground 'highlight-indent-guides-character-face "dimgray")
;;(add-hook 'c++-mode-hook 'highlight-indent-guides-mode)
;;(add-hook 'java-mode-hook 'highlight-indent-guides-mode)
;;(add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

(use-package hl-todo
  :hook ((org-mode . hl-todo-mode)
         (prog-mode . hl-todo-mode))
  :config
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        `(("TODO"       warning bold)
          ("FIXME"      error bold)
          ("HACK"       font-lock-constant-face bold)
          ("REVIEW"     font-lock-keyword-face bold)
          ("NOTE"       success bold)
          ("DEPRECATED" font-lock-doc-face bold))))

(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

(use-package counsel
  :bind (("C-x b" . 'counsel-ibuffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l"
        lsp-modeline-diagnostics-enable nil)
  :hook ((LaTeX-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration)
         (julia-mode . lsp)
         (c-mode . lsp)
         (c++-mode . lsp)
         (C++-mode . lsp)
         (java-mode . lsp)
         (sh-mode . lsp)
         (haskell-mode . lsp)
         (css-mode . lsp)
         (tex-mode . lsp))
  :custom
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  (lsp-inlay-hint-enable t)
  (lsp-log-io t)
  (lsp-diagnostics-provider :flycheck) ;; Explicitly use Flycheck
  :config
  (setq lsp-rust-analyzer-display-lifetime-elision-hints-enable t
        lsp-rust-analyzer-display-chaining-hints t
        lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil
        lsp-rust-analyzer-display-closure-return-type-hints t
        lsp-rust-analyzer-display-parameter-hints nil
        lsp-rust-analyzer-display-reborrow-hints nil))

(use-package lsp-latex
  :ensure t
  :hook (bibtex-mode . lsp))

(use-package lsp-ui
  :ensure t
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :ensure t
  :after lsp)

(use-package lsp-ivy
  :ensure t
  :after lsp)

(use-package lsp-pyright
:ensure t
:after lsp-mode
:hook (python-mode . (lambda ()
                       (require 'lsp-pyright)
                       (lsp-deferred))))  ;; or just (lsp) if you prefer

        (require 'package)

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("C-u" . company-complete-selection)
         ("C-j" . company-select-next)
         ("C-k" . company-select-previous))
        (:map lsp-mode-map
         ("C-i" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :ensure t
  :after company
  :hook (company-mode . company-box-mode))

(use-package dap-mode
  ;; Uncomment the config below if you want all UI panes to be hidden by default!
  ;; :custom
  ;; (lsp-enable-dap-auto-configure nil)
  ;; :config
  ;; (dap-ui-mode 1)
  :commands dap-debug
  :config
  ;; Set up Node debugging
  (require 'dap-node)
  (dap-node-setup)) ;; Automatically installs Node debug adapter if needed

(use-package lsp-java
  :hook (java-mode . lsp-deferred))

(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :custom
  ;; NOTE: Set these if Python 3 is called "python3" on your system!
  ;; (python-shell-interpreter "python3")
  ;; (dap-python-executable "python3")
  (dap-python-debugger 'debugpy)
  :config
  (require 'dap-python))

(use-package lsp-julia
       :after lsp-mode
        :config
(setq lsp-julia-default-environment "~/.julia/environments/v1.11"))

(use-package verilog-mode
  :ensure t
  :hook (verilog-mode . (lambda ()
                          (require 'verilog-mode)
                          (lsp))))

(use-package ccls
:ensure t
:hook ((c-mode c++-mode objc-mode cuda-mode) .
       (lambda () (require 'ccls) (lsp)))
:config
(progn
  (setq ccls-executable "/usr/bin/ccls")
  (setq ccls-initialization-options
        '(:index (:comments 2) :completion (:detailedLabel t)))))

(use-package haskell-mode
  :ensure t
  :hook (haskell-mode . interactive-haskell-mode))

(use-package scala-mode
  :mode "\\.s\\(cala\\|bt\\)$")

(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map))

(use-package lsp-metals
  :ensure t
  :custom
  ;; You might set metals server options via -J arguments. This might not always work, for instance when
  ;; metals is installed using nix. In this case you can use JAVA_TOOL_OPTIONS environment variable.
  (lsp-metals-server-args '(;; Metals claims to support range formatting by default but it supports range
                            ;; formatting of multiline strings only. You might want to disable it so that
                            ;; emacs can use indentation provided by scala-mode.
                            "-J-Dmetals.allow-multiline-string-formatting=off"
                            ;; Enable unicode icons. But be warned that emacs might not render unicode
                            ;; correctly in all cases.
                            "-J-Dmetals.icons=unicode"))
  ;; In case you want semantic highlighting. This also has to be enabled in lsp-mode using
  ;; `lsp-semantic-tokens-enable' variable. Also you might want to disable highlighting of modifiers
  ;; setting `lsp-semantic-tokens-apply-modifiers' to `nil' because metals sends `abstract' modifier
  ;; which is mapped to `keyword' face.
  (lsp-metals-enable-semantic-highlighting t)
  :hook (scala-mode . lsp))

(global-set-key [escape] 'keyboard-escape-quit)

(use-package toc-org
  :diminish
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable)
  (setq org-agenda-start-on-weekday 1))

(add-hook 'org-mode-hook 'org-indent-mode)
(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(require 'org-tempo)

(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)))

(use-package perspective
  :custom
  ;; NOTE! I have also set 'SCP =' to open the perspective menu.
  ;; I'm only setting the additional binding because setting it
  ;; helps suppress an annoying warning message.
  (persp-mode-prefix-key (kbd "C-c M-p"))
  :init 
  (persp-mode)
  :config
  ;; Sets a file to write to when we save states
  (setq persp-state-default-file "~/.config/emacs/sessions"))

;; This will group buffers by persp-name in ibuffer.
(add-hook 'ibuffer-hook
          (lambda ()
            (persp-ibuffer-set-filter-groups)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              (ibuffer-do-sort-by-alphabetic))))

;; Automatically save perspective states to file when Emacs exits.
(add-hook 'kill-emacs-hook #'persp-state-save)

(use-package rainbow-delimiters
  :hook ((emacs-lisp-mode . rainbow-delimiters-mode)
         (clojure-mode . rainbow-delimiters-mode)))

(use-package rainbow-mode
  :diminish
  :hook 
  ((org-mode prog-mode) . rainbow-mode))

(use-package eshell-syntax-highlighting
  :after esh-mode
  :config
  (eshell-syntax-highlighting-global-mode +1))

;; eshell-syntax-highlighting -- adds fish/zsh-like syntax highlighting.
;; eshell-rc-script -- your profile for eshell; like a bashrc for eshell.
;; eshell-aliases-file -- sets an aliases file for the eshell.

(setq eshell-rc-script (concat user-emacs-directory "eshell/profile")
      eshell-aliases-file (concat user-emacs-directory "eshell/aliases")
      eshell-history-size 5000
      eshell-buffer-maximum-lines 5000
      eshell-hist-ignoredups t
      eshell-scroll-to-bottom-on-input t
      eshell-destroy-buffer-when-process-dies t
      eshell-visual-commands'("bash" "fish" "htop" "ssh" "top" "zsh"))

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-tokyo-night t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package tree-sitter
      :diminish
      :init
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))
(use-package tree-sitter-langs
    :diminish)

(use-package which-key
  :init
  (which-key-mode 1)
  :config
  (setq which-key-side-window-location 'bottom
        which-key-sort-order #'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-slot -10
        which-key-side-window-max-height 0.25
        which-key-idle-delay 0.8
        which-key-max-description-length 25
        which-key-allow-imprecise-window-fit nil 
        which-key-separator " → " ))

(use-package yasnippet
  :ensure t
  :hook ((LaTeX-mode . yas-minor-mode)
         (post-self-insert . my/yas-try-expanding-auto-snippets)))

(setq yas-triggers-in-field t)

;; Function that tries to autoexpand YaSnippets
;; The double quoting is NOT a typo!
(defun my/yas-try-expanding-auto-snippets ()
  (when (and (boundp 'yas-minor-mode) yas-minor-mode)
    (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
      (yas-expand))))
