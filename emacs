(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))
(setq inhibit-startup-message t) ;; No splash screen
(setq initial-scratch-message nil) ;; No scratch message
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
(defvar blink-cursor-colors (list  "#92c48f" "#6785c5" "#be369c" "#d9ca65")
  "On each blink the cursor will cycle to the next color in this list.")

(setq blink-cursor-count 0)
(defun blink-cursor-timer-function ()
  "Zarza wrote this cyberpunk variant of timer `blink-cursor-timer'. 
Warning: overwrites original version in `frame.el'.

This one changes the cursor color on each blink. Define colors in `blink-cursor-colors'."
  (when (not (internal-show-cursor-p))
    (when (>= blink-cursor-count (length blink-cursor-colors))
      (setq blink-cursor-count 0))
    (set-cursor-color (nth blink-cursor-count blink-cursor-colors))
    (setq blink-cursor-count (+ 1 blink-cursor-count))
    )
  (internal-show-cursor nil (not (internal-show-cursor-p)))
  )
(blink-cursor-mode t)

(require 'cl)
(defun unicode-symbol (name)
  "Translate a symbolic name for a Unicode character -- e.g., LEFT-ARROW
  or GREATER-THAN into an actual Unicode character code. "
  (decode-char 'ucs (case name
                          ;; arrows
                          ('left-arrow 8592)
                          ('up-arrow 8593)
                          ('right-arrow 8594)
                          ('down-arrow 8595)
                          ;; boxes
                          ('double-vertical-bar #X2551)
                          ;; relational operators
                          ('equal #X003d)
                          ('not-equal #X2260)
                          ('identical #X2261)
                          ('not-identical #X2262)
                          ('less-than #X003c)
                          ('greater-than #X003e)
                          ('less-than-or-equal-to #X2264)
                          ('greater-than-or-equal-to #X2265)
                          ;; logical operators
                          ('logical-and #X2227)
                          ('logical-or #X2228)
                          ('logical-neg #X00AC)
                          ;; misc
                          ('nil #X2205)
                          ('horizontal-ellipsis #X2026)
                          ('double-exclamation #X203C)
                          ('prime #X2032)
                          ('double-prime #X2033)
                          ('for-all #X2200)
                          ('there-exists #X2203)
                          ('element-of #X2208)
                          ;; mathematical operators
                          ('square-root #X221A)
                          ('squared #X00B2)
                          ('cubed #X00B3)
                          ;; letters
                          ('lambda #X03BB)
                          ('alpha #X03B1)
                          ('beta #X03B2)
                          ('gamma #X03B3)
                          ('delta #X03B4))))

(defun substitute-pattern-with-unicode (pattern symbol)
  "Add a font lock hook to replace the matched part of PATTERN with the 
  Unicode symbol SYMBOL looked up with UNICODE-SYMBOL."
  (interactive)
  (font-lock-add-keywords
   nil `((,pattern (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                             ,(unicode-symbol symbol))
                             nil))))))

(defun substitute-patterns-with-unicode (patterns)
  "Call SUBSTITUTE-PATTERN-WITH-UNICODE repeatedly."
  (mapcar #'(lambda (x)
              (substitute-pattern-with-unicode (car x)
                                               (cdr x)))
          patterns))

(defun ocaml-unicode ()
  (interactive)
  (substitute-patterns-with-unicode
   (list (cons "\\(<-\\)" 'left-arrow)
         (cons "\\(->\\)" 'right-arrow)
         (cons "\\[^=\\]\\(=\\)\\[^=\\]" 'equal)
         (cons "\\(==\\)" 'identical)
         (cons "\\(\\!=\\)" 'not-identical)
         (cons "\\(<>\\)" 'not-equal)
         (cons "\\(()\\)" 'nil)
         (cons "\\<\\(sqrt\\)\\>" 'square-root)
         (cons "\\(&&\\)" 'logical-and)
         (cons "\\(||\\)" 'logical-or)
         (cons "\\<\\(not\\)\\>" 'logical-neg)
         (cons "\\(>\\)\\[^=\\]" 'greater-than)
         (cons "\\(<\\)\\[^=\\]" 'less-than)
         (cons "\\(>=\\)" 'greater-than-or-equal-to)
         (cons "\\(<=\\)" 'less-than-or-equal-to)
         (cons "\\<\\(alpha\\)\\>" 'alpha)
         (cons "\\<\\(beta\\)\\>" 'beta)
         (cons "\\<\\(gamma\\)\\>" 'gamma)
         (cons "\\<\\(delta\\)\\>" 'delta)
         (cons "\\(''\\)" 'double-prime)
         (cons "\\('\\)" 'prime)
         (cons "\\<\\(List.for_all\\)\\>" 'for-all)
         (cons "\\<\\(List.exists\\)\\>" 'there-exists)
         (cons "\\<\\(List.mem\\)\\>" 'element-of)
         ;;(cons "^ +\\(|\\)" 'double-vertical-bar)
         )))
(add-hook 'tuareg-mode-hook 'ocaml-unicode)
(load-theme 'solarized-light t)
(add-to-list 'auto-mode-alist '("\.ml$" . tuareg-mode))