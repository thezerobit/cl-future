#|
  This file is a part of cl-future project.
  Copyright (c) 2012 Stephen A. Goss (steveth45@gmail.com)
|#

(in-package :cl-user)
(defpackage cl-future
  (:use :cl :cl-cont :alexandria)
  (:import-from :fset
                #:seq
                #:with-last
                #:empty?
                #:less-first)
  (:export #:future
           #:ident
           #:done-p
           #:register-future
           #:complete-future
           #:make-future
           #:register-action
           #:run-actions
           #:yield
           #:wait-for
           #:with-call/cc))
(in-package :cl-future)

;; classes
(defclass future ()
  ((ident :initform (gensym) :reader ident)
   (val :accessor val)
   (completed-cb :accessor completed-cb :initform nil)))

;; parameters
(defparameter *actions* (seq))

;; functions
(defun done-p (future)
  (slot-boundp future 'val))

(defun make-future ()
  (make-instance 'future))

(defun register-action (action)
  (setf *actions* (with-last *actions* action)))

(defun run-actions ()
  (loop while (not (empty? *actions*))
        do (let ((next (fset:first *actions*)))
             (setf *actions* (less-first *actions*))
             (funcall next))))

(defun complete-future (future val)
  (setf (val future) val)
  (when-let ((callbacks (completed-cb future)))
    (setf (completed-cb future) nil)
    (dolist (callback callbacks) (register-action callback))))

(defun/cc yield ()
  (let/cc continuation
    (register-action continuation)))

(defun/cc wait-for (future)
  (let/cc continuation
    (if (not (done-p future))
      (push continuation (completed-cb future))
      (funcall continuation)))
  (val future))
