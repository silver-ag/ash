#lang racket

;;;;;;;;;;;;;;;;;;;
;; default macros
;;;;

(struct macro
  (arity
   proc
   builtin?))

(define define-mac
  (macro 2
         (λ (ash-stx)
           (list (if (equal? (first (third ash-stx)) 'function-application)
                     'defun 'defvar)
                 (third ash-stx)
                 (fourth ash-stx)))
         #t))

(define if-mac
  (macro 3
         (λ (ash-stx)
           `(if ,(third ash-stx) ,(fourth ash-stx) ,(fifth ash-stx)))
         #t))

(define default-macros
  (hash "op_eq" define-mac
        #"if" if-mac))

;;;;;;;;;;;;
;; default functions
;;;;

(define autocurry
  ;; autocurry runs a function if it has enough arguments, otherwise it returns a new function that takes the remaining arguments
  (format
   "function autocurry(f, args) {~
      if (args.length > f.length) {~
        console.log('error: too many arguments');~
      } else if (args.length == f.length) {~
        return f.apply(null,args);~
      } else {~
        var remaining = f.length - args.length;~
        var wrapper_args = [];~
        for (var i = 0; i < remaining; i++) {~
          wrapper_args.push('_'+i);~
        }~
        return Function('f','args','return function ('+wrapper_args.join(',')+'){return f.apply(null,args.concat(Array.from(arguments)))}')(f,args);~
      }~
    }\n"))

(define ash-plus
  "function op_plus(a,b) { return a + b; }\n")

(define ash-minus
  "function op_dash(a,b) { return a - b; }\n")

(define ash-times
  "function op_star(a,b) { return a * b; }\n")

(define ash-divide
  "function op_slash(a,b) { return a / b; }\n")

(define ash-expt
  "function op_caret(a,b) { return Math.pow(a,b); }\n")

(define ash-and
  "function op_amp(a,b) { return a && b; }\n")

(define ash-or
  "function op_pipe(a,b) { return a || b; }\n")

(define ash-print
  "function print(a) { console.log(a); return a; }\n")

(define ash-equal
  "function op_eqeq(a,b) { return a == b; }\n")

(define ash-neq
  "function op_bangeq(a,b) { return a != b; }\n")

(define base-js
  (string-append autocurry
                 ash-plus
                 ash-minus
                 ash-times
                 ash-divide
                 ash-expt
                 ash-and
                 ash-or
                 ash-print
                 ash-equal
                 ash-neq))

(provide default-macros base-js (struct-out macro))