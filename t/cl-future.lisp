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

(defparameter *f1* (make-future))
(defparameter *f2* nil)

(register-action
  (lambda ()
    (with-call/cc
      (let ((f2 (make-future)))
        (princ "Hello, ")
        (setf *f2* f2)
        (wait-for *f1*)
        (wait-for f2)
        (princ "World.")
        nil))))

(register-action
  (lambda ()
    (with-call/cc
      (wait-for *f1*)
      (princ "... "))))

(register-action (lambda () (complete-future *f2* 'someval)))
(register-action (lambda () (complete-future *f1* 'someval)))

(run-actions)
;; output: Hello, ... World.

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
;; output: a1b2c3d4

(finalize)
