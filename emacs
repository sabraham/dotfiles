(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/emacs-color-theme-solarized")
(load-theme 'solarized-light t)
(load-theme 'solarized-dark t)
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
    '("marmalade" .
          "http://www.marmalade-repo.org/packages/"))
(package-initialize)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'slime-repl-mode-hook 'clojure-mode-font-lock-setup)
(require 'slime)
(require 'slime-repl)