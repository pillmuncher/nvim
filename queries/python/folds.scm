;; Keep decorators visible, fold only the body

;; Functions: fold just the body
(function_definition
  body: (_) @fold)

;; Classes: fold just the body
(class_definition
  body: (_) @fold)
