(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/emacs-color-theme-solarized")
;;(add-to-list 'custom-theme-load-path "~/.emacs.d/emacs-color-theme-solarized")
(add-to-list 'load-path "~/.emacs.d/color-theme")
(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))
(setq inhibit-startup-message t) ;; No splash screen
(setq initial-scratch-message nil) ;; No scratch message
(if
    (equal 0 (string-match "^24" emacs-version))
    ;; it's emacs24, so use built-in theme
    (require 'solarized-light-theme)
  ;; it's NOT emacs24, so use color-theme
  (progn
    (require 'color-theme)
    (color-theme-initialize)
    (require 'color-theme-solarized)
    (color-theme-solarized-light)))
(define-key global-map (kbd "RET") 'newline-and-indent)
(autoload 'octave-mode "octave-mod" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))
(add-hook 'octave-mode-hook
	  (lambda ()
	    (abbrev-mode 1)
	    (auto-fill-mode 1)
	    (if (eq window-system 'x)
		(font-lock-mode 1))))
(setq load-path (cons (expand-file-name "~/.emacs.d/") load-path))
(autoload 'word-count-mode "word-count"
  "Minor mode to count words." t nil)
(global-set-key "\M-+" 'word-count-mode)
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)
(add-to-list 'load-path "~/.emacs.d/vendor")
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))
(require 'paredit)
(require 'highlight-parentheses)
(require 'fill-column-indicator)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'clojure-mode-hook
          (lambda ()
            (highlight-parentheses-mode t)
            (fci-mode t)
            (paredit-mode t)
            (set-fill-column 80)
            (setq hl-paren-colors
              '("red1" "orange1" "yellow1" "green1" "cyan1"
                "slateblue1" "magenta1" "purple"))))
(setq scheme-program-name
      "/Applications/mit-scheme.app/Contents/Resources/mit-scheme")
(require 'xscheme)
(add-hook 'scheme-mode-hook
          (lambda ()
            (highlight-parentheses-mode t)
            (fci-mode t)
            (paredit-mode t)
            (set-fill-column 80)
            (setq hl-paren-colors
              '("red1" "orange1" "yellow1" "green1" "cyan1"
                "slateblue1" "magenta1" "purple"))))
