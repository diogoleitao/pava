;; Advanced Programming 2015/2016
;;
;; APL - A Programming Language
;;
;;Group 26
;; Diogo Leitao 69644
;; Diana Ribeiro 70096

;;Auxiliary functions
(defun factorial (n)
	(if (= n 0) 1
		(* n (factorial (- n 1)))))

;;Class definition for tensors, scalars and vectors
(defclass tensorClass ()
	((elements :type list
		   :initform '()
		   :initarg :elements
		   :accessor elements-slot)
	  (size :type list
		:initarg :size
		:accessor size-slot)
	)
)

(defclass scalarClass (tensorClass)
	((elements :type list
			:initform '()
			:initarg :elements)
	  (size :type list
			:initform '(1)
			:initarg :size)
	)
)

(defclass vectorClass (tensorClass)
	((elements :type list
		   :initform '()
		   :initarg :elements)
	  (size :type list
			:initform '()
			:initarg :size)
	)
)

(defun s(scalar)
	(make-instance 'scalarClass
				   :elements (list scalar)))

(defun v(&rest vals)
	(make-instance 'vectorClass
				   :elements vals
				   :size (list (list-length vals))))

;; TODO
(defmethod print-object((obj tensorClass) out)
	(print-unreadable-object (obj out :type t)
		(print (elements-slot obj))
	)
)

;(defgeneric .- (tensor1 tensor2))

;(defgeneric ./ (tensor1 tensor2))

(defgeneric catenate (tensor1 tensor2))


;;Monadic Functions - functions that receive only one argument
(defun interval (scalar))

;(defmethod drop ((scalar n) (tensor tsr)))

;(defmethod drop ((tensor1 tensorClass) (tensor2 tensorClass))))

(defun reshape ((tensor1 tensorClass) (tensor2 tensorClass)))

(defun outer-product (func))

(defun inner-product (func1 func2))

(defun fold (func))

(defun .- ((obj tensorClass))
	(let ((tAux (make-instance 'tensorClass :elements (elements-slot obj)))
			(lAux '()))
		(if (eql (elements-slot tAux) '())
			'()
			(if (not (listp (car (elements-slot tAux))))
				(progn
					(dolist (el (elements-slot tAux))
						(setf el (* -1 el))
						(setf lAux (append lAux (list el)))
					)
					(setf (elements-slot tAux) lAux)
				)
				(setf (elements-slot tAux)
					  (cons (elements-slot (.- (make-instance 'tensorClass
																:elements (car (elements-slot tAux)))))
							(elements-slot (.- (make-instance 'tensorClass
															:elements (cdr (elements-slot tAux)))))))
			)
		)
	tAux)
)

(defun ./ ((obj tensorClass))
	(let ((tAux (make-instance 'tensorClass :elements (elements-slot obj)))
			(lAux '()))
		(if (eql (elements-slot tAux) '())
			'()
			(if (not (listp (car (elements-slot tAux))))
				(progn
					(dolist (el (elements-slot tAux))
						(setf el (/ 1 el)) ;; VER QUANDO É ZERO
						(setf lAux (append lAux (list el)))
					)
					(setf (elements-slot tAux) lAux)
				)
				(setf (elements-slot tAux)
					  (cons (elements-slot (./ (make-instance 'tensorClass
																:elements (car (elements-slot tAux)))))
							(elements-slot (./ (make-instance 'tensorClass
															:elements (cdr (elements-slot tAux)))))))
			)
		)
	tAux)
)

(defun .sin ((obj tensorClass))
	(let ((tAux (make-instance 'tensorClass :elements (elements-slot obj)))
			(lAux '()))
		(if (eql (elements-slot tAux) '())
			'()
			(if (not (listp (car (elements-slot tAux))))
				(progn
					(dolist (el (elements-slot tAux))
						(setf el (sin el))
						(setf lAux (append lAux (list el)))
					)
					(setf (elements-slot tAux) lAux)
				)
				(setf (elements-slot tAux)
					  (cons (elements-slot (.sin (make-instance 'tensorClass
																:elements (car (elements-slot tAux)))))
							(elements-slot (.sin (make-instance 'tensorClass
															:elements (cdr (elements-slot tAux)))))))
			)
		)
	tAux)
)

(defun .cos ((obj tensorClass))
	(let ((tAux (make-instance 'tensorClass :elements (elements-slot obj)))
			(lAux '()))
		(if (eql (elements-slot tAux) '())
			'()
			(if (not (listp (car (elements-slot tAux))))
				(progn
					(dolist (el (elements-slot tAux))
						(setf el (cos el))
						(setf lAux (append lAux (list el)))
					)
					(setf (elements-slot tAux) lAux)
				)
				(setf (elements-slot tAux)
					  (cons (elements-slot (.cos (make-instance 'tensorClass
																:elements (car (elements-slot tAux)))))
							(elements-slot (.cos (make-instance 'tensorClass
															:elements (cdr (elements-slot tAux)))))))
			)
		)
	tAux)
)

(defun .!((obj tensorClass))
	(let ((tAux (make-instance 'tensorClass :elements (elements-slot obj)))
			(lAux '()))
		(if (eql (elements-slot tAux) '())
			'()
			(if (not (listp (car (elements-slot tAux))))
				(progn
					(dolist (el (elements-slot tAux))
						(setf el (factorial el))
						(setf lAux (append lAux (list el)))
					)
					(setf (elements-slot tAux) lAux)
				)
				(setf (elements-slot tAux)
					  (cons (elements-slot (.! (make-instance 'tensorClass
																:elements (car (elements-slot tAux)))))
							(elements-slot (.! (make-instance 'tensorClass
															:elements (cdr (elements-slot tAux)))))))
			)
		)
	tAux)
)

;; The result is a tensor containing, as elements, the integers 0 or 1 if the element of the given tensor is different than or equal to zero
(defun .not ((obj tensorClass))
	(let ((tAux (make-instance 'tensorClass :elements (elements-slot obj)))
			(lAux '()))
		(if (eql (elements-slot tAux) '())
			'()
			(if (not (listp (car (elements-slot tAux))))
				(progn
					(dolist (el (elements-slot tAux))
						(if (= el 0)
							(setf el 1)
							(setf el 0)
						)
						(setf lAux (append lAux (list el)))
					)
					(setf (elements-slot tAux) lAux)
				)
				(setf (elements-slot tAux)
					  (cons (elements-slot (.not (make-instance 'tensorClass
																:elements (car (elements-slot tAux)))))
							(elements-slot (.not (make-instance 'tensorClass
															:elements (cdr (elements-slot tAux)))))))
			)
		)
	tAux)
)

;;Dyadic functions - functions that receive two arguments
(defmethod catenate ((scalar1 scalarClass) (scalar2 scalarClass)))

(defmethod catenate ((tensor1 tensorClass) (tensor2 tensorClass)))

(defun member? ((tsr tensorClass) (scl scalarClass)))

(defun select ((tensor1 tensorClass) (tensor2 tensorClass)))

(defun scan ((tensor1 tensorClass) (tensor2 tensorClass)))


;;For the following functions the test cases are:
;; 1- The tensors have the same size. The auxiliary tensor always has the size of tensor1
;; 2- Tensor1 is a scalar, so the auxiliary tensor has the size of tensor2
;; 3- Tensor2 is a scalar, so the auxiliary tensor has the size of tensor1
;; else an error is returned because the sizes are incompatible
(defun .+ ((tensor1 tensorClass) (tensor2 tensorClass)))

;(defmethod .- ((tensor1 tensorClass) (tensor2 tensorClass)))

;(defmethod ./ ((tensor1 tensorClass) (tensor2 tensorClass)))

(defun .* ((tensor1 tensorClass) (tensor2 tensorClass)))

(defun .// ((tensor1 tensorClass) (tensor2 tensorClass)))

(defun .% ((tensor1 tensorClass) (tensor2 tensorClass)))

;;For the following functions the test cases are:
;; 1- The tensors have the same size. The auxiliary tensor always has the size of tensor1
;;		1.1 - for each element of the tensors a logical operation is performed, if T, tAux is filled with 1, otherwise with 0
;; 2- Tensor1 is a scalar, so the auxiliary tensor has the size of tensor2
;;		2.1 - for each element of tensor2 a logical operation is performed with tensor1, if T, tAux is filled with 1, otherwise with 0
;; 3- Tensor2 is a scalar, so the auxiliary tensor has the size of tensor1
;;		3.1 - for each element of tensor1 a logical operation is performed with tensor2, if T, tAux is filled with 1, otherwise with 0
;; else an error is returned because the sizes are incompatible
(defun .> ((tensor1 tensorClass) (tensor2 tensorClass)))

(defun .< ((tensor1 tensorClass) (tensor2 tensorClass)))

(defun .>= ((tensor1 tensorClass) (tensor2 tensorClass)))

(defun .<= ((tensor1 tensorClass) (tensor2 tensorClass)))

(defun .= ((tensor1 tensorClass) (tensor2 tensorClass)))

(defun .or ((tensor1 tensorClass) (tensor2 tensorClass)))

(defun .and ((tensor1 tensorClass) (tensor2 tensorClass)))
