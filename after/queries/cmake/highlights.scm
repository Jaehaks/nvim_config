; extends

;; Highlighting specific options of the file() command
((normal_command
   (identifier) @function.builtin
   (argument_list
     (argument) @keyword))
 (#eq? @function.builtin "file")
 (#match? @keyword "^(GLOB|GLOB_RECURSE|CONFIGURE_DEPENDS|RELATIVE|LIST_DIRECTORIES)$"))

;; specific options for set()
((normal_command
   (identifier) @function.builtin
   (argument_list
     (argument) @keyword))
 (#eq? @function.builtin "set")
 (#match? @keyword "^(CACHE|FORCE|PARENT_SCOPE)$"))

;; Highlighting scope options
((normal_command
   (argument_list
     (argument) @keyword))
 (#match? @keyword "^(PUBLIC|PRIVATE|INTERFACE|IMPORTED|DEBUG|RELEASE|GLOBAL)$"))

;; Highlighting scope options2
((normal_command
   (argument_list
     (argument) @keyword))
 (#match? @keyword "^(STATIC|SHARED|ALIAS|MODULE|UNKNOWN|OBJECT|EXCLUDE_FROM_ALL)$"))

;; Highlighting scope options2
((normal_command
   (argument_list
     (argument) @keyword))
 (#match? @keyword "^(PROPERTIES|TARGET|SOURCE|DIRECTORY|PROPERTY|APPEND|APPEND_STRING)$"))

