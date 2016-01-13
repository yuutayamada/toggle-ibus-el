;;; toggle-ibus.el --- -*- lexical-binding: t; -*-

;; Copyright (C) 2016 by Yuta Yamada

;; Author: Yuta Yamada <cokesboy"at"gmail.com>
;; Version: 0.0.1
;; Keywords: ibus

;;; License:
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;; Commentary:
;;
;;   Toggle ibus’s state.
;;
;;; Code:

(require 'cl-lib)
(defun tibus-get-engines ()
  (mapcar
   (lambda (str) (substring str 0 (1- (length str))))
   (split-string
    (cadr (split-string
           (shell-command-to-string
            "echo -n `ibus read-config | grep 'engines-order: '`")
           "engines-order: \\["))
    " ")))

(defvar tibus-engines (tibus-get-engines))
(defvar tibus-toggle-state (car tibus-engines))
(defvar tibus-after-toggle-hook nil)

(defun tibus-set-engine (engine)
  "Set ibus engine to ENGINE."
  (cl-destructuring-bind (primary _secondary) (tibus-get-engines)
    (unless (equal engine primary)
      (call-process-shell-command
       (format "ibus engine %s &" engine))
      (setq tibus-toggle-state engine))))

;;;###autoload
(defun tibus-toggle (&optional engine)
  (interactive)
  (cl-destructuring-bind (_primary secondary) (tibus-get-engines)
    (tibus-set-engine (or engine secondary)))
  (run-hooks 'tibus-after-toggle-hook))

(provide 'toggle-ibus)

;; Local Variables:
;; coding: utf-8
;; mode: emacs-lisp
;; End:

;;; toggle-ibus.el ends here
