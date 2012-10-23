#|
  This file is a part of cl-future project.
  Copyright (c) 2012 Stephen A. Goss (steveth45@gmail.com)
|#

(in-package :cl-user)
(defpackage cl-future-test
  (:use :cl
        :cl-future
        :cl-test-more))
(in-package :cl-future-test)

(plan nil)

;; example 1: futures

(defparameter *f1-id* nil)
(defparameter *f2-id* nil)

(register-action
  (lambda ()
    (with-call/cc
      (let ((f1 (make-future))
            (f2 (make-future)))
        (princ "Hello, ")
        (setf *f1-id* (ident f1))
        (setf *f2-id* (ident f2))
        (wait-for f1)
        (wait-for f2)
        (princ "World.")
        nil))))

(register-action (lambda () (complete-future *f2-id* 'someval)))
(register-action (lambda () (princ "... ")))
(register-action (lambda () (complete-future *f1-id* 'someval)))

(run-actions)

;; example 2: cooperative multitasking

(register-action
  (lambda ()
    (with-call/cc
      (dolist (letter (list "a" "b" "c" "d"))
        (princ letter)
        (yield)))))

(register-action
  (lambda ()
    (with-call/cc
      (dolist (number (list "1" "2" "3" "4"))
        (princ number)
        (yield)))))

(run-actions)

(finalize)
