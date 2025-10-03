(brack_group_key_value
  "[" @delimiter
  "]" @delimiter @sentinel) @container

(curly_group
  "{" @delimiter
  "}" @delimiter @sentinel) @container

(curly_group_text
  "{" @delimiter
  "}" @delimiter @sentinel) @container

(curly_group_text_list
  "{" @delimiter
  "}" @delimiter @sentinel) @container

(inline_formula
  "$" @delimiter
  "$" @delimiter @sentinel) @container

(curly_group_path
  "{" @delimiter
  "}" @delimiter @sentinel) @container

(curly_group_path_list
  "{" @delimiter
  "}" @delimiter @sentinel) @container

(curly_group_author_list
  "{" @delimiter
  "}" @delimiter @sentinel) @container

; INFO: () cannot be rainbow colorized. Because nested '()' doesn't have hierarchical structure.
;		More exactly, '()' cannot be included in latex treesitter.
;		But \( \) can be nested structure so it can be rainbow colorized

; INFO: \{ \} cannot be rainbow colorized. Because \{ and \} are separated nodes that named with 'genetic_command'.
;		They cannot be belonged to one container

; \( \)
(inline_formula
  "\\(" @delimiter
  "\\)" @delimiter @sentinel) @container

; \[ \]
(displayed_equation
  "\\[" @delimiter
  "\\]" @delimiter @sentinel) @container

; INFO: It is impossible to colorize both '\left' and '(' with same color. Even though we tie these in [] array.
;  		You need to choose one between colorizing '\left' only or '(' only.
; 	 	I decide to colorize ( because If this node has error, the whole word '\left(' will be colorized.
;		If you set query both of them, \left and ( will have different color and They act in pairs.
;		but it is annoying as I think.
;
;		\left\{ is different because the query has 'left_delimiter' and 'right_delimiter' unlike ( and [.
;		the \{ will belong to 'left_delimiter' and we colorize this.

; (math_delimiter
;   "\\left" @delimiter
;   "\\right" @delimiter @sentinel) @container

; for \left( \right\)
(math_delimiter
  "(" @delimiter
  ")" @delimiter @sentinel) @container

; for \left[ \right\]
(math_delimiter
  "[" @delimiter
  "]" @delimiter @sentinel) @container

; for \left\{ \right\}
(math_delimiter
  left_delimiter:(command_name)  @delimiter
  right_delimiter:(command_name)  @delimiter @sentinel) @container

