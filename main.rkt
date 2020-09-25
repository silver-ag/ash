#lang racket

(define *version* "0.1.0")

;; TODO:
;; add default macros
;; add default functions

(require "compiler.rkt")

(define (main arguments)
  (let [[arguments (if (empty? arguments) '("help") arguments)]]
    (case (first arguments)
      [("c" "compile")
       (let-values [[(outfile filename code)
                     (run-compiler (rest arguments))]]
         (if (check-file outfile)
             (begin (delete-file outfile)
                    (with-output-to-file outfile (λ () (display code))))
             (with-output-to-file outfile (λ () (display code)))))]
      [("r" "run")
       (let-values [[(outfile filename code)
                     (run-compiler (rest arguments))]]
         (if (check-file outfile)
             (begin (delete-file outfile)
                    (with-output-to-file outfile (λ () (display code))))
             (with-output-to-file outfile (λ () (display code))))
         (if (node-exists?)
             (system (format "node ~a" outfile) #:set-pwd? #t)
             (error "nodejs must be installed to run code")))]
      [("h" "help" "-h" "-help" "--help")
       (display helptext)])))

(define (run-compiler args)
  (define output-file "out.js")
  (let [[filename
          (command-line
           #:argv args
           #:once-each [("-o" "--out") file "output file" (set! output-file file)]
           #:args (filename) filename)]]
    (if (check-file filename)
        (values output-file filename (compile filename))
        (error "could not access file"))))

(define (node-exists?)
  (define (check procinfo stdin stdout stderr)
    (if (equal? (procinfo 'status) 'running)
      (check procinfo stdin stdout stderr)
      (begin
        (close-output-port stdin)
        (close-input-port stdout)
        (close-input-port stderr)
        (equal? (procinfo 'status) 'done-ok))))
  (let [[proc (process "node -v")]]
    (check (fifth proc) (second proc) (first proc) (fourth proc))))

(define (check-file filename)
  (and (file-exists? filename)
       (member 'read (file-or-directory-permissions filename))))

(define helptext
  (format
   "Ash Compiler v~a
usage: ash [compile|run|help] filename\n
MODE
compile,c    compile filename and write it to out.js
run,r        compile as above, then execute out.js using node
               (nodejs must be installed)
help         show this help text\n"
   *version*))

;;;;;;;;;;;;;;;;;;;;;;
;; actually run main
;;;;
;; commented out for testing in drracket
;(let [] ;; used to avoid printing the return value of main automatically (there must be a better way)
;  (main (vector->list (current-command-line-arguments)))
;  (void))