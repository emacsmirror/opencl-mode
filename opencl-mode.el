;;; opencl-mode.el --- Syntax coloring for opencl kernels

;; Copyright (c) 2014 - Salmane Bah <salmane.bah@u-bordeaux.fr>
;;
;; Author: Salmane Bah <salmane.bah@u-bordeaux.fr>
;; Keywords: c, opencl
;; URL: https://github.com/salmanebah/opencl-mode
;; Version: 1.0

;; This file is NOT part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Installation:

;; 1- Put this file in your load path or optionally add this line to your Emacs init file:
;;    (add-to-list 'load-path "/path/to/directory/where/opencl-mode.el/resides")
;; 2- Add these lines to your Emacs init file
;;    (require 'opencl-mode)
;;    (add-to-list 'auto-mode-alist '("\\.cl\\'" . opencl-mode))

;;; Code:

;; for c-font-lock-keywords
(require 'cc-fonts)

(make-variable-buffer-local
 (defvar *opencl-extension-color* "#A82848"
  "opencl extension color"))

(defface font-lock-opencl-face
  `((t (:foreground ,*opencl-extension-color* :weight bold)))
  "custom face for cl-extension"
  :group 'opencl-faces)

(make-variable-buffer-local
 (defvar opencl-keywords-regexp
   "\\(__\\)?\\(kernel\\|global\\|local\\|constant\\|private\\|read_only\\|write_only\\|read_write\\|enable\\|disable\\)[[:blank:]\n]+"
   "Regexp for opencl keywords"))

(make-variable-buffer-local
 (defvar opencl-functions-regexp
   (regexp-opt '("get_work_dim" "get_global_size"
		 "get_local_size" "get_global_id"
		 "get_local_id" "get_num_groups"
		 "get_group_id" "get_global_offset") 'words)
   "Regexp for builtin opencl fucntions"))

(make-variable-buffer-local
  (defvar opencl-constant-regexp
    (regexp-opt '("MAXFLOAT" "HUGE_VALF"
		  "INFINITY" "NAN" "HUGE_VAL") 'words)
    "Regexp for opencl constant"))

(make-variable-buffer-local
 (defvar opencl-types-regexp
   "\\(char\\|short\\|half\\|int\\|double\\|float\\|long\\|uchar\\|ushort\\|uint\\|ulong\\)[[:digit:]]\\{0,2\\}[[:blank:]\n]+"
   "Regexp for opencl primitive types"))

(make-variable-buffer-local
 (defvar opencl-scalar-types-regexp
   (regexp-opt '("bool" "size_t" "ptrdiff_t" "intptr_t" "uintptr_t")
	       'words)
   "Regexp for opencl scalar types"))

(make-variable-buffer-local
 (defvar opencl-image-type-regexp
   (regexp-opt '("image2d_t" "image3d_t"
		 "image2d_array_t" "image3d_array_t"
		 "image1d_array_t" "image1d_t"
		 "image1d_buffer_t" "sampler_t"
		 "event_t") 'words)
   "Regexp for opencl image types"))

(make-variable-buffer-local
 (defvar opencl-extension-regexp "cl_khr_[a-zA-Z][a-zA-Z_0-9]+"
   "Regex for opencl extensions"))

(make-variable-buffer-local
 (defvar opencl-font-lock-keywords
   `((,opencl-functions-regexp . font-lock-builtin-face)
     (,opencl-types-regexp . font-lock-type-face)
     (,opencl-scalar-types-regexp . font-lock-type-face)
     (,opencl-constant-regexp . font-lock-constant-face)
     (,opencl-keywords-regexp . font-lock-keyword-face)
     (,opencl-image-type-regexp . font-lock-type-face)
     (,opencl-extension-regexp . 'font-lock-opencl-face))
   "Font-lock for opencl keywords"))


(define-derived-mode opencl-mode c-mode "Opencl"
  "Major mode for opencl kernel editing"
  (setcar font-lock-defaults (append c-font-lock-keywords opencl-font-lock-keywords)))

(defun opencl-lookup ()
  "Get opencl documentation for string in region or point."
  (interactive)
  (let (api-function doc-url)
    (setq api-function
	  (if (region-active-p)
	      (buffer-substring-no-properties (region-beginning)
					      (region-end))
	    (thing-at-point 'symbol)))
    (setq doc-url (concat
		   "http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/"
		   api-function ".html"))
    (browse-url doc-url)))

(define-key opencl-mode-map (kbd "C-c ! d") 'opencl-lookup)

(provide 'opencl-mode)
;;; opencl-mode.el ends here
