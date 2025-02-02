;; extends
; if ";; extends" doesn't exist, it override markdown treesitter
; and it makes render-markdown malfunction

; Match pipe-delimited text using inline content
; (
;   (inline) @underline.pipe
;   (#match? @underline.pipe "^\\|[^|]+\\|$")
;   (#offset! @underline.pipe 0 1 0 -1)
; )

; Capture entire inline content between pipes (|...|)
; (
;   (inline) @underline.pipe
;   (#lua-match? @underline.pipe "|[^|]+|")
;   (#set! "priority" 105)  ; Override default markdown queries
; )

