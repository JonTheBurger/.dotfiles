; extends

(redirected_statement
  redirect: (heredoc_redirect
    redirect: (file_redirect
      destination: (string) @filename)
    (heredoc_body) @injection.content)
  (#match? @filename ".*\\.json")
  (#set! injection.language "json")
  (#set! injection.combined))
