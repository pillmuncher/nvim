;; Extend function.outer to include the trailing newline/indent
(
  (function_definition) @function.outer
)
(
  (function_definition
    body: (block) @function.inner)
)
