;; Advanced Programming 2015/2016
;;
;; APL - A Programming Language
;;
;;Group 26
;; Diogo Leitao 69644
;; Diana Ribeiro 70096

;; Tensor (of numbers) and booleans representation
;; Note: true is 1 and false is 0
;; @Diana: I think lists are a good data structure to represent tensors
(defun tensor(dim values)
	(make-array dim :initial-contents values))

;; Scalar and vector creation
;; e.g.: (s 2) prints out 2 and
;; 		 (v 1 2 3) prints out 1 2 3
(defun s(scalar)
	(tensor (list 1) (list scalar)))

(defun v(&rest rest))

(defun reshape(dimensions tensor))

(defun interval(scalar))

(defun drop(elements))

(defun inner-product(func1 func2))

(defun outer-product(function))

(defun catenate(arg1 arg2))

(defun member?(tensor element))

(defun select(tensor tensor))

(defun fold(function))

(defun scan(tensor tensor))
