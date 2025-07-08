; Function calls from common SQL libraries
(
  (call
    function: (attribute
                object: (_) ; Match any object like `con`
                attribute: (identifier) @_method
                (#any-of? @_method "execute" "executemany" "executescript"))
    arguments: (argument_list
                 (string
                   (string_content) @injection.content
                   (#set! injection.language "sql"))))
)

; For kwargs of sql="..."
(call
  function: (_)
  arguments: (argument_list
               (keyword_argument
                 name: (identifier) @_kw
                 (#eq? @_kw "sql") ; still specific to keyword `sql`
                 value: (string
                          (string_content) @injection.content
                          (#set! injection.language "sql")))))

; Variables ending in "_sql" and "_SQL"
(expression_statement
  (assignment
    left: (identifier) @_left
    (#match? @_left "(_sql|_SQL)$")
    right: (string
      (string_content) @injection.content
      (#set! injection.language "sql"))))

; Variables ending in "_json" and "_JSON"
(expression_statement
  (assignment
    left: (identifier) @_left
    (#match? @_left "(_json|_JSON)$")
    right: (string
      (string_content) @injection.content
      (#set! injection.language "json"))))

; Docstrings are markdown
((expression_statement (string (string_content) @injection.content))
  (#set! injection.language "markdown"))

; ; Doc-strings are markdown
(function_definition
  (block
    (expression_statement
      (string
        (string_content) @injection.content
        (#set! injection.language "markdown")))))
