; I don't understand what @endable means
; ((function_definition name: (_) (function_arguments) @cursor) @endable @indent (#endwise! "end"))
; ((class_definition    name: (_) @cursor) @endable @indent (#endwise! "end"))
; ((properties          (_) @cursor) @endable @indent (#endwise! "end"))
; ((methods             (_) @cursor) @endable @indent (#endwise! "end"))
((while_statement     condition: (_) @cursor) @endable @indent (#endwise! "end"))
((for_statement       (iterator) @cursor) @endable @indent (#endwise! "end"))
((if_statement        condition: (_) @cursor) @endable @indent (#endwise! "end"))
((block  (if_statement)  condition: (_) @cursor) @endable @indent (#endwise! "end"))


(((function_definition name: (_) (function_arguments) @cursor) @indent) (#endwise! "end" ))
; ((ERROR ("classdef"  . (_) @cursor) @indent) (#endwise! "end" ))
; ((ERROR ("classdef"  . (_) (methods) @cursor) @indent) (#endwise! "end" ))
; ((ERROR ("classdef"  . (properties) @cursor) @indent) (#endwise! "end" ))
; ((ERROR ("properties". (_) @cursor) @indent) (#endwise! "end" ))
; ((ERROR ("methods"   . (_) @cursor) @indent) (#endwise! "end" ))
((ERROR ("while"     . (_) @cursor) @indent) (#endwise! "end"))
((ERROR ("for"       . (_) @cursor) @indent) (#endwise! "end"))
((ERROR ("if"        . (_) @cursor) @indent) (#endwise! "end"))