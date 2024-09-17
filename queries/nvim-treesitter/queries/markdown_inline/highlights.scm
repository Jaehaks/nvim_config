;; extends

; (
; 	(inline) @markup.underline
; 	(#match? @markup.underline "\\+([^+]+)\\+")
; 	;; (#set! conceal "")
; 	(#offset! @markup.underline 0 0 0 0)
; )

;; ((inline) @markup.underline
;;   (#match? @markup.underline "\\+")
;;   (#offset! @markup.underline 0 1 0 -1)
;;   (#set! conceal ""))

;; ((inline) @markup.bold.underline
;;   (#match? @markup.bold.underline "\\*\\*\\+([^+]+)\\+\\*\\*")
;;   (#offset! @markup.bold.underline 0 3 0 -3)
;;   (#set! conceal ""))
;;
;; ((inline) @conceal.plus
;;   (#match? @conceal.plus "(?<=[\\s\\(]|^)\\+(?=[^+])")
;;   (#set! conceal ""))
;;
;; ((inline) @conceal.plus
;;   (#match? @conceal.plus "(?<=[^+])\\+(?=[\\s\\)]|$)")
;;   (#set! conceal ""))
