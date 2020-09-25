#lang racket

(require brag/support)
(require (for-syntax racket/list))

(require "grammar.rkt") ;; provides parse

(define (ash-parse path port)
  (parse path (reverse (tokenise port))))

(define (tokenise port (tokens '()))
  ;; note result is in reverse
  (if (equal? (peek-char port) eof)
      tokens
      (let [[new-token
             (regexp-try-case
              port
              [#rx"^//[^\n]*(\n|$)" 'discard]
              [#rx"^~{(([^}~]|[^}]~|}(?!~))*)}~" (token 'JSLITERAL (second match))]
              [#rx"^[0-9]+(\\.[0-9]+)?" (token 'NUMBER (first match))]
              [#rx"^\"([^\"]|\\\")*\"" ;; uses read to remove a layer of escaping
               (token 'STRING (read (open-input-string (bytes->string/utf-8 (first match)))))]
              [#rx"^[a-zA-Z_\\.]+" (token 'SYMBOL (first match))]
              [#rx"^[-+*/><=!^&|%$~#?:.]+" (token 'OPERATOR (first match))]
              [#rx"^[ \n\t]+" 'discard]
              [else (read-char port)])]]
        (tokenise port (if (equal? new-token 'discard) tokens (cons new-token tokens)))))) ;; note that port is mutated by regexp matches

(define-syntax (regexp-try-case stx)
  ;; gives the consequent expression access to a 'match' binding
  (define dtm (syntax->datum stx))
  (datum->syntax
   stx
   `(cond
      ,@(map (λ (branch)
               (if (equal? (first branch) 'else)
                   branch
                   `[(regexp-match-peek ,(first branch) ,(second dtm))
                     ((λ (match) ,@(rest branch)) (regexp-try-match ,(first branch) ,(second dtm)))]))
             (drop dtm 2)))))


(provide (rename-out (ash-parse parse)))
(provide ash-parse)