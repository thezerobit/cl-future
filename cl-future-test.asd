#|
  This file is a part of cl-future project.
  Copyright (c) 2012 Stephen A. Goss (steveth45@gmail.com)
|#

(in-package :cl-user)
(defpackage cl-future-test-asd
  (:use :cl :asdf))
(in-package :cl-future-test-asd)

(defsystem cl-future-test
  :author "Stephen A. Goss"
  :license "Modified BSD"
  :depends-on (:cl-future
               :cl-test-more)
  :components ((:module "t"
                :components
                ((:file "cl-future"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
