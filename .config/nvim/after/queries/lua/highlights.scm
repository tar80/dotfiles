;; extends
((comment) @comment.todo
  (#lua-match? @comment.todo "TODO") (#set! "priority" 150))
((comment) @comment.note
  (#lua-match? @comment.note "NOTE") (#set! "priority" 150))
