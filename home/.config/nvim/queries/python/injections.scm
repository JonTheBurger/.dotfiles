; Module Docstrings are markdown
(
  (expression_statement
    (string
      (string_content) @injection.content)
    )
  (#set! injection.language "markdown")
)

; Function Docstrings are markdown
(function_definition
  (block
    (expression_statement
      (string
        (string_content) @injection.content
        (#set! injection.language "markdown")
      )
    )
  )
)

; Function calls to json library
(
  (call
    function:
      (attribute
        object: (_)
        attribute: (identifier) @_method
        (#any-of? @_method "loads")
      )
    arguments:
      (argument_list
        (string
          (string_content) @injection.content
          (#set! injection.language "json")
        )
      )
  )
)

; Variables ending with "_json" and "_JSON"
(expression_statement
  (assignment
    left: (identifier) @_left
    (#match? @_left "(_json|_JSON)$")
    right:
      (string
        (string_content) @injection.content
        (#set! injection.language "json")
      )
  )
)

; Variables starting with "HTML_" or ending with "_html" and "_HTML"
(expression_statement
  (assignment
    left: (identifier) @_left
    (#match? @_left "(^HTML_|_html$|_HTML$)")
    right:
      (string
        (string_content) @injection.content
        (#set! injection.language "html")
      )
  )
)

; Variables ending with "_sql" and "_SQL"
(expression_statement
  (assignment
    left: (identifier) @_left
    (#match? @_left "(_sql|_SQL)$")
    right: (string
      (string_content) @injection.content
      (#set! injection.language "sql")
    )
  )
)

; Function calls from common SQL libraries
(
  (call
    function:
      (attribute
        object: (_) ; Match any object
        attribute: (identifier) @_method
        (#any-of? @_method "execute" "executemany" "executescript")
      )
    arguments:
      (argument_list
        (string
          (string_content) @injection.content
          (#set! injection.language "sql")
        )
      )
  )
)

; For kwargs of sql="..."
(call
  function: (_)
  arguments:
    (argument_list
      (keyword_argument
        name: (identifier) @_kw
        (#eq? @_kw "sql")
        value:
          (string
            (string_content) @injection.content
            (#set! injection.language "sql")
          )
      )
    )
)

; For to do comments
(
  (comment) @injection.content
  (#match? @injection.content "TODO|BUG|FIXME|NOTE|HACK|FUTURE")
  (#set! injection.language "comment" "todo")
)

; For lint comments
(
  (comment) @injection.content
  (#match? @injection.content "NOLINT|NOLINTNEXTLINE|NOLINTBEGIN|NOLINTEND")
  (#set! injection.language "comment" "todo")
)
