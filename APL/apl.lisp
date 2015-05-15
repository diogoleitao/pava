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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

(defgeneric .- (tensorClass))

(defgeneric ./ (tensorClass))

(defgeneric catenate (tensorClass scalarClass))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;Monadic Functions - functions that receive only one argument
(defun interval (scalar)
	(let ((lAux '())
			(vAux (make-instance 'vectorClass :elements '())))
		(dotimes (i (- 1 scalar))
				(cons (+ 1 i) lAux)
		)
		(setf (elements-slot vAux) lAux)
	vAux)
)

(defmethod drop ((n scalarClass) (tsr tensorClass))
	(let ((lAux '())
			(tAux (make-instance 'tensorClass)))
		 (if (not (equal (car (elements-slot tsr)) '()))
			 (if (not (listp (car (elements-slot tsr))))
				 (let ((a (make-array (list-length (elements-slot tsr)) :initial-contents (elements-slot tsr))))
					  (if (< n 0)
						  (progn
							  (dotimes (i (- (array-dimension a 0) 1))
									(setf lAux (append lAux (list(aref a (+ i n))))))
							  (setf (elements-slot tAux) lAux))
						  (progn
							  (dotimes (i (- (array-dimension a 0) 1 n))
									(setf lAux (append lAux (list (aref a i)))))
							  (setf (elements-slot tAux) lAux))))
				 (setf lAux (append lAux (drop n (make-instance 'tensorClass :elements (cdr (elements-slot tsr)))))))
			'()
		)
	tAux)
)

;;(defmethod drop ((tensor1 tensorClass) (tensor2 tensorClass))))

;;(defmethod reshape ((tensor1 tensorClass) (tensor2 tensorClass)))

;;(defmethod outer-product (func))

;;(defmethod inner-product (func1 func2))

(defun fold (func)
	(lambda (vec)
		(let ((aAux (make-array (size-slot vec)
								:initial-contents (elements-slot vec))))
			(do ((i 1 (1+ i)))
				((> (+ i 1) (car (size-slot vec))))
				(setf (aref aAux 0)
					  (funcall func (aref aAux 0) (aref aAux i)))
			)
		(aref aAux 0))
	)
)

(defmethod .- ((obj tensorClass))
	(let ((tAux (make-instance 'tensorClass :elements (elements-slot obj)))
			(lAux '()))
		(if (equal (elements-slot tAux) '())
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

(defmethod ./ ((obj tensorClass))
	(let ((tAux (make-instance 'tensorClass :elements (elements-slot obj)))
			(lAux '()))
		(if (equal (elements-slot tAux) '())
			'()
			(if (not (listp (car (elements-slot tAux))))
				(progn
					(dolist (el (elements-slot tAux))
						(if (= el 0)
							(setf el 0)
							(setf el (/ 1 el))
						)
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

(defmethod .sin ((obj tensorClass))
	(let ((tAux (make-instance 'tensorClass :elements (elements-slot obj)))
			(lAux '()))
		(if (equal (elements-slot tAux) '())
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

(defmethod .cos ((obj tensorClass))
	(let ((tAux (make-instance 'tensorClass :elements (elements-slot obj)))
			(lAux '()))
		(if (equal (elements-slot tAux) '())
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

(defmethod .!((obj tensorClass))
	(let ((tAux (make-instance 'tensorClass :elements (elements-slot obj)))
			(lAux '()))
		(if (equal (elements-slot tAux) '())
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
(defmethod .not ((obj tensorClass))
	(let ((tAux (make-instance 'tensorClass :elements (elements-slot obj)))
			(lAux '()))
		(if (equal (elements-slot tAux) '())
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;Dyadic functions - functions that receive two arguments
(defmethod catenate ((scalar1 scalarClass) (scalar2 scalarClass))
	(let ((vAux (make-instance 'vectorClass)))
		 (setf (elements-slot vAux)
			   (append (elements-slot scalar1)
					   (elements-slot scalar2)))
	vAux)
)

(defmethod catenate ((tensor1 tensorClass) (tensor2 tensorClass))
	(let ((lAux '())
			(tAux (make-instance 'tensorClass)))
		 (if (not (equal (car (elements-slot tensor1)) '()))
			 (if (not (listp (car (elements-slot tensor1))))
				 (dolist (el (elements-slot tensor1))
						(setf lAux (append lAux (list el)))
						(print "t1")
						(print lAux))
				 (setf lAux (append lAux (catenate (make-instance 'tensorClass :elements (car (elements-slot tensor1)))
												   (make-instance 'tensorClass :elements (cdr (elements-slot tensor1))))))))
		 (if (not (equal (car (elements-slot tensor2)) '()))
			 (if (not (listp (car (elements-slot tensor2))))
				 (dolist (el (elements-slot tensor2))
						(setf lAux (append lAux (list el)))
						(print "t2")
						(print lAux))
				 (setf lAux (append lAux (catenate (make-instance 'tensorClass :elements (car (elements-slot tensor2)))
												   (make-instance 'tensorClass :elements (cdr (elements-slot tensor2))))))))
	(setf (elements-slot tAux) lAux)
	tAux)
)

;;(defmethod member? ((tsr tensorClass) (scl scalarClass)))

;;(defmethod select ((tensor1 tensorClass) (tensor2 tensorClass)))

;;(defmethod scan ((tensor1 tensorClass) (tensor2 tensorClass)))


;;For the following functions the test cases are:
;; 1- The tensors have the same size. The auxiliary tensor always has the size of tensor1
;; 2- Tensor1 is a scalar, so the auxiliary tensor has the size of tensor2
;; 3- Tensor2 is a scalar, so the auxiliary tensor has the size of tensor1
;; else an error is returned because the sizes are incompatible

(defmethod .+ ((tensor1 tensorClass) (tensor2 tensorClass))
	;;tensors have the same size
	(if (equal (size-slot tensor1)
			   (size-slot tensor2))
		(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1))))
			 (if (equal (elements-slot tensor1) '())
				'()
				(if (not (and (listp (car (elements-slot tensor1)))
							  (listp (car (elements-slot tensor2)))))
					(let ((a1 (make-array (list-length (elements-slot tensor1)) :initial-contents (elements-slot tensor1)))
							(a2 (make-array (list-length (elements-slot tensor2)) :initial-contents (elements-slot tensor2)))
								(l1 '()))
							(dotimes (i (array-dimension a1 0))
								(setf l1 (append l1 (list(+ (aref a1 i) (aref a2 i)))))
							)
							(setf (elements-slot tAux) l1))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.+ (make-instance 'tensorClass
																  :elements (car (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (car (elements-slot tensor2)))))
								(elements-slot (.+ (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor2)))))))
				)
			)
		tAux)
		;;tensor1 is a scalar
		(if (equal (size-slot tensor1) '(1))
			(let ((tAux (make-instance 'tensorClass :size (size-slot tensor2)))
				(lAux '()))
			 (if (equal (elements-slot tAux) '())
				 '()
				 (if (not(listp (car (elements-slot tensor1))))
					(progn
						(dolist (el (elements-slot tensor2))
							(setf lAux (append lAux (list (+ (car (elements-slot tensor1)) el)))))
						(setf (elements-slot tAux) lAux))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.+ tensor1 (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor2)))))
								(elements-slot (.+ tensor1 (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2)))))))
				))
			tAux)
			;;tensor2 is a scalar
			(if (equal (size-slot tensor2) '(1))
				(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1)))
						(lAux '()))
					 (if (equal (elements-slot tAux) '())
						'()
						(if (not(listp (car (elements-slot tensor2))))
							(progn
								(dolist (el (elements-slot tensor1))
									(setf lAux (append lAux (list (+ el (car(elements-slot tensor2)))))))
								(setf (elements-slot tAux) lAux))
							(setf (elements-slot tAux)
								  (cons (elements-slot (.+ (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor1))) tensor2))
										(elements-slot (.+ (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2))) tensor2))))
						)
					)
				tAux)
		)))
)

(defmethod .- ((tensor1 tensorClass) (tensor2 tensorClass))
	;;tensors have the same size
	(if (equal (size-slot tensor1)
			   (size-slot tensor2))
		(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1))))
			 (if (equal (elements-slot tensor1) '())
				'()
				(if (not (and (listp (car (elements-slot tensor1)))
							  (listp (car (elements-slot tensor2)))))
					(let ((a1 (make-array (list-length (elements-slot tensor1)) :initial-contents (elements-slot tensor1)))
							(a2 (make-array (list-length (elements-slot tensor2)) :initial-contents (elements-slot tensor2)))
								(l1 '()))
							(dotimes (i (array-dimension a1 0))
								(setf l1 (append l1 (list (- (aref a1 i) (aref a2 i)))))
							)
							(setf (elements-slot tAux) l1))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.- (make-instance 'tensorClass
																  :elements (car (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (car (elements-slot tensor2)))))
								(elements-slot (.- (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor2)))))))
				)
			)
		tAux)
		;;tensor1 is a scalar
		(if (equal (size-slot tensor1) '(1))
			(let ((tAux (make-instance 'tensorClass :size (size-slot tensor2)))
				(lAux '()))
			 (if (equal (elements-slot tAux) '())
				 '()
				 (if (not(listp (car (elements-slot tensor1))))
					(progn
						(dolist (el (elements-slot tensor2))
							(setf lAux (append lAux (list (- (car (elements-slot tensor1)) el)))))
						(setf (elements-slot tAux) lAux))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.- tensor1 (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor2)))))
								(elements-slot (.- tensor1 (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2)))))))
				))
			tAux)
			;;tensor2 is a scalar
			(if (equal (size-slot tensor2) '(1))
				(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1)))
						(lAux '()))
					 (if (equal (elements-slot tAux) '())
						'()
						(if (not(listp (car (elements-slot tensor2))))
							(progn
								(dolist (el (elements-slot tensor1))
									(setf lAux (append lAux (list (- el (car(elements-slot tensor2)))))))
								(setf (elements-slot tAux) lAux))
							(setf (elements-slot tAux)
								  (cons (elements-slot (.- (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor1))) tensor2))
										(elements-slot (.- (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2))) tensor2))))
						)
					)
				tAux)
		)))
)

(defmethod ./ ((tensor1 tensorClass) (tensor2 tensorClass))
	;;tensors have the same size
	(if (equal (size-slot tensor1)
			   (size-slot tensor2))
		(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1))))
			 (if (equal (elements-slot tensor1) '())
				'()
				(if (not (and (listp (car (elements-slot tensor1)))
							  (listp (car (elements-slot tensor2)))))
					(let ((a1 (make-array (list-length (elements-slot tensor1)) :initial-contents (elements-slot tensor1)))
							(a2 (make-array (list-length (elements-slot tensor2)) :initial-contents (elements-slot tensor2)))
								(l1 '()))
							(dotimes (i (array-dimension a1 0))
								(setf l1 (append l1 (list (/ (aref a1 i) (aref a2 i)))))
							)
							(setf (elements-slot tAux) l1))
					(setf (elements-slot tAux)
						  (cons (elements-slot (./ (make-instance 'tensorClass
																  :elements (car (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (car (elements-slot tensor2)))))
								(elements-slot (./ (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor2)))))))
				)
			)
		tAux)
		;;tensor1 is a scalar
		(if (equal (size-slot tensor1) '(1))
			(let ((tAux (make-instance 'tensorClass :size (size-slot tensor2)))
				(lAux '()))
			 (if (equal (elements-slot tAux) '())
				 '()
				 (if (not(listp (car (elements-slot tensor1))))
					(progn
						(dolist (el (elements-slot tensor2))
							(setf lAux (append lAux (list (/ (car (elements-slot tensor1)) el)))))
						(setf (elements-slot tAux) lAux))
					(setf (elements-slot tAux)
						  (cons (elements-slot (./ tensor1 (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor2)))))
								(elements-slot (./ tensor1 (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2)))))))
				))
			tAux)
			;;tensor2 is a scalar
			(if (equal (size-slot tensor2) '(1))
				(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1)))
						(lAux '()))
					 (if (equal (elements-slot tAux) '())
						'()
						(if (not(listp (car (elements-slot tensor2))))
							(progn
								(dolist (el (elements-slot tensor1))
									(setf lAux (append lAux (list (/ el (car(elements-slot tensor2)))))))
								(setf (elements-slot tAux) lAux))
							(setf (elements-slot tAux)
								  (cons (elements-slot (./ (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor1))) tensor2))
										(elements-slot (./ (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2))) tensor2))))
						)
					)
				tAux)
		)))
)

(defmethod .* ((tensor1 tensorClass) (tensor2 tensorClass))
	;;tensors have the same size
	(if (equal (size-slot tensor1)
			   (size-slot tensor2))
		(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1))))
			 (if (equal (elements-slot tensor1) '())
				'()
				(if (not (and (listp (car (elements-slot tensor1)))
							  (listp (car (elements-slot tensor2)))))
					(let ((a1 (make-array (list-length (elements-slot tensor1)) :initial-contents (elements-slot tensor1)))
							(a2 (make-array (list-length (elements-slot tensor2)) :initial-contents (elements-slot tensor2)))
								(l1 '()))
							(dotimes (i (array-dimension a1 0))
								(setf l1 (append l1 (list (* (aref a1 i) (aref a2 i)))))
							)
							(setf (elements-slot tAux) l1))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.* (make-instance 'tensorClass
																  :elements (car (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (car (elements-slot tensor2)))))
								(elements-slot (.* (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor2)))))))
				)
			)
		tAux)
		;;tensor1 is a scalar
		(if (equal (size-slot tensor1) '(1))
			(let ((tAux (make-instance 'tensorClass :size (size-slot tensor2)))
				(lAux '()))
			 (if (equal (elements-slot tAux) '())
				 '()
				 (if (not(listp (car (elements-slot tensor1))))
					(progn
						(dolist (el (elements-slot tensor2))
							(setf lAux (append lAux (list (* (car (elements-slot tensor1)) el)))))
						(setf (elements-slot tAux) lAux))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.* tensor1 (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor2)))))
								(elements-slot (.* tensor1 (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2)))))))
				))
			tAux)
			;;tensor2 is a scalar
			(if (equal (size-slot tensor2) '(1))
				(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1)))
						(lAux '()))
					 (if (equal (elements-slot tAux) '())
						'()
						(if (not(listp (car (elements-slot tensor2))))
							(progn
								(dolist (el (elements-slot tensor1))
									(setf lAux (append lAux (list (* el (car(elements-slot tensor2)))))))
								(setf (elements-slot tAux) lAux))
							(setf (elements-slot tAux)
								  (cons (elements-slot (.* (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor1))) tensor2))
										(elements-slot (.* (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2))) tensor2))))
						)
					)
				tAux)
		)))
)

(defmethod .// ((tensor1 tensorClass) (tensor2 tensorClass))
	;;tensors have the same size
	(if (equal (size-slot tensor1)
			   (size-slot tensor2))
		(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1))))
			 (if (equal (elements-slot tensor1) '())
				'()
				(if (not (and (listp (car (elements-slot tensor1)))
							  (listp (car (elements-slot tensor2)))))
					(let ((a1 (make-array (list-length (elements-slot tensor1)) :initial-contents (elements-slot tensor1)))
							(a2 (make-array (list-length (elements-slot tensor2)) :initial-contents (elements-slot tensor2)))
								(l1 '()))
							(dotimes (i (array-dimension a1 0))
								(setf l1 (append l1 (list (car (list(floor (aref a1 i) (aref a2 i)))))))
							)
							(setf (elements-slot tAux) l1))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.// (make-instance 'tensorClass
																  :elements (car (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (car (elements-slot tensor2)))))
								(elements-slot (.// (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor2)))))))
				)
			)
		tAux)
		;;tensor1 is a scalar
		(if (equal (size-slot tensor1) '(1))
			(let ((tAux (make-instance 'tensorClass :size (size-slot tensor2)))
				(lAux '()))
			 (if (equal (elements-slot tAux) '())
				 '()
				 (if (not(listp (car (elements-slot tensor1))))
					(progn
						(dolist (el (elements-slot tensor2))
							(setf lAux (append lAux (list (car (list(floor (car (elements-slot tensor1)) el)))))))
						(setf (elements-slot tAux) lAux))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.// tensor1 (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor2)))))
								(elements-slot (.// tensor1 (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2)))))))
					)
				)
			tAux)
			;;tensor2 is a scalar
			(if (equal (size-slot tensor2) '(1))
				(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1)))
						(lAux '()))
					 (if (equal (elements-slot tAux) '())
						'()
						(if (not(listp (car (elements-slot tensor2))))
							(progn
								(dolist (el (elements-slot tensor1))
									(setf lAux (append lAux (list (car (list(floor el (car(elements-slot tensor2)))))))))
								(setf (elements-slot tAux) lAux))
							(setf (elements-slot tAux)
								  (cons (elements-slot (.// (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor1))) tensor2))
										(elements-slot (.// (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2))) tensor2))))
						)
					)
				tAux)
		)))
)

(defmethod .% ((tensor1 tensorClass) (tensor2 tensorClass))
	;;tensors have the same size
	(if (equal (size-slot tensor1)
			   (size-slot tensor2))
		(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1))))
			 (if (equal (elements-slot tensor1) '())
				'()
				(if (not (and (listp (car (elements-slot tensor1)))
							  (listp (car (elements-slot tensor2)))))
					(let ((a1 (make-array (list-length (elements-slot tensor1)) :initial-contents (elements-slot tensor1)))
							(a2 (make-array (list-length (elements-slot tensor2)) :initial-contents (elements-slot tensor2)))
								(l1 '()))
							(dotimes (i (array-dimension a1 0))
								(setf l1 (append l1 (list (rem (aref a1 i) (aref a2 i)))))
							)
							(setf (elements-slot tAux) l1))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.% (make-instance 'tensorClass
																  :elements (car (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (car (elements-slot tensor2)))))
								(elements-slot (.% (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor2)))))))
				)
			)
		tAux)
		;;tensor1 is a scalar
		(if (equal (size-slot tensor1) '(1))
			(let ((tAux (make-instance 'tensorClass :size (size-slot tensor2)))
					(lAux '()))
				 (if (equal (elements-slot tAux) '())
						'()
						(if (not(listp (car (elements-slot tensor1))))
							(progn
								(dolist (el (elements-slot tensor2))
									(setf lAux (append lAux (list (rem (car (elements-slot tensor1)) el)))))
								(setf (elements-slot tAux) lAux))
							(setf (elements-slot tAux)
								  (cons (elements-slot (.% tensor1 (make-instance 'tensorClass
																				  :elements (car (elements-slot tensor2)))))
										(elements-slot (.% tensor1 (make-instance 'tensorClass
																				  :elements (cdr (elements-slot tensor2)))))))
				))
			tAux)
			;;tensor2 is a scalar
			(if (equal (size-slot tensor2) '(1))
				(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1)))
						(lAux '()))
					 (if (equal (elements-slot tAux) '())
						'()
						(if (not(listp (car (elements-slot tensor2))))
							(progn
								(dolist (el (elements-slot tensor1))
									(setf lAux (append lAux (list (rem el (car (elements-slot tensor2)))))))
								(setf (elements-slot tAux) lAux))
							(setf (elements-slot tAux)
								  (cons (elements-slot (.% (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor1))) tensor2))
										(elements-slot (.% (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2))) tensor2))))
						)
					)
				tAux)
		)))
)
;;For the following functions the test cases are:
;; 1- The tensors have the same size. The auxiliary tensor always has the size of tensor1
;;		1.1 - for each element of the tensors a logical operation is performed, if T, tAux is filled with 1, otherwise with 0
;; 2- Tensor1 is a scalar, so the auxiliary tensor has the size of tensor2
;;		2.1 - for each element of tensor2 a logical operation is performed with tensor1, if T, tAux is filled with 1, otherwise with 0
;; 3- Tensor2 is a scalar, so the auxiliary tensor has the size of tensor1
;;		3.1 - for each element of tensor1 a logical operation is performed with tensor2, if T, tAux is filled with 1, otherwise with 0
;; else an error is returned because the sizes are incompatible

(defmethod .> ((tensor1 tensorClass) (tensor2 tensorClass))
	;;tensors have the same size
	(if (equal (size-slot tensor1)
			   (size-slot tensor2))
		(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1))))
			 (if (equal (elements-slot tensor1) '())
				'()
				(if (not (and (listp (car (elements-slot tensor1)))
							  (listp (car (elements-slot tensor2)))))
					(let ((a1 (make-array (list-length (elements-slot tensor1)) :initial-contents (elements-slot tensor1)))
							(a2 (make-array (list-length (elements-slot tensor2)) :initial-contents (elements-slot tensor2)))
								(l1 '()))
							(dotimes (i (array-dimension a1 0))
								(if (> (aref a1 i) (aref a2 i))
									(setf l1 (append l1 (list 1)))
									(setf l1 (append l1 (list 0)))
								)
							)
							(setf (elements-slot tAux) l1))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.> (make-instance 'tensorClass
																  :elements (car (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (car (elements-slot tensor2)))))
								(elements-slot (.> (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor2)))))))
				)
			)
		tAux)
		;;tensor1 is a scalar
		(if (equal (size-slot tensor1) '(1))
			(let ((tAux (make-instance 'tensorClass :size (size-slot tensor2)))
				(lAux '()))
			 (if (equal (elements-slot tAux) '())
				 '()
				 (if (not(listp (car (elements-slot tensor1))))
					(progn
						(dolist (el (elements-slot tensor2))
							(if (> (car (elements-slot tensor1)) el)
								(setf el 1)
								(setf el 0))
							(setf lAux (append lAux (list el))))

						(setf (elements-slot tAux) lAux))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.> tensor1 (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor2)))))
								(elements-slot (.> tensor1 (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2)))))))
				))
			tAux)
			;;tensor2 is a scalar
			(if (equal (size-slot tensor2) '(1))
				(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1)))
				(lAux '()))
				(if (equal (elements-slot tAux) '())
					'()
					(if (not(listp (car (elements-slot tensor2))))
						(progn
							(dolist (el (elements-slot tensor1))
								(if (> el (car(elements-slot tensor2)))
									(setf el 1 )
									(setf el 0))
								(setf lAux (append lAux (list el))))
							(setf (elements-slot tAux) lAux))
						(setf (elements-slot tAux)
							(cons (elements-slot (.> (make-instance 'tensorClass
																	:elements (car (elements-slot tensor1))) tensor2))
								  (elements-slot (.> (make-instance 'tensorClass
																	:elements (cdr (elements-slot tensor2))) tensor2))))
					))
				tAux)
		)))
)

(defmethod .< ((tensor1 tensorClass) (tensor2 tensorClass))
	;;tensors have the same size
	(if (equal (size-slot tensor1)
			   (size-slot tensor2))
		(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1))))
			 (if (equal (elements-slot tensor1) '())
				'()
				(if (not (and (listp (car (elements-slot tensor1)))
							  (listp (car (elements-slot tensor2)))))
					(let ((a1 (make-array (list-length (elements-slot tensor1)) :initial-contents (elements-slot tensor1)))
							(a2 (make-array (list-length (elements-slot tensor2)) :initial-contents (elements-slot tensor2)))
								(l1 '()))
							(dotimes (i (array-dimension a1 0))
								(if (< (aref a1 i) (aref a2 i))
									(setf l1 (append l1 (list 1)))
									(setf l1 (append l1 (list 0)))
								)
							)
							(setf (elements-slot tAux) l1))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.< (make-instance 'tensorClass
																  :elements (car (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (car (elements-slot tensor2)))))
								(elements-slot (.< (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor2)))))))
				)
			)
		tAux)
		;;tensor1 is a scalar
		(if (equal (size-slot tensor1) '(1))
			(let ((tAux (make-instance 'tensorClass :size (size-slot tensor2)))
				(lAux '()))
			 (if (equal (elements-slot tAux) '())
				 '()
				 (if (not(listp (car (elements-slot tensor1))))
					(progn
						(dolist (el (elements-slot tensor2))
								(if (< (car (elements-slot tensor1)) el)
									(setf el 1)
									(setf el 0)
								)
							(setf lAux (append lAux (list el))))

						(setf (elements-slot tAux) lAux))

					(setf (elements-slot tAux)
						  (cons (elements-slot (.< tensor1 (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor2)))))
								(elements-slot (.< tensor1 (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2)))))))
				))
			tAux)
			;;tensor2 is a scalar
			(if (equal (size-slot tensor2) '(1))
				(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1)))
				(lAux '()))
				(if (equal (elements-slot tAux) '())
					'()
					(if (not(listp (car (elements-slot tensor2))))
						(progn
							(dolist (el (elements-slot tensor1))
								(if (< el (car(elements-slot tensor2)))
									(setf el 1 )
									(setf el 0)
								)
								(setf lAux (append lAux (list el))))

						(setf (elements-slot tAux) lAux))

					(setf (elements-slot tAux)
						(cons (elements-slot (.< (make-instance 'tensorClass
																	:elements (car (elements-slot tensor1))) tensor2))
								(elements-slot (.< (make-instance 'tensorClass
																:elements (cdr (elements-slot tensor2))) tensor2))))
					))
				tAux)
		)))
)

(defmethod .>= ((tensor1 tensorClass) (tensor2 tensorClass))
	;;tensors have the same size
	(if (equal (size-slot tensor1)
			   (size-slot tensor2))
		(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1))))
			 (if (equal (elements-slot tensor1) '())
				'()
				(if (not (and (listp (car (elements-slot tensor1)))
							  (listp (car (elements-slot tensor2)))))
					(let ((a1 (make-array (list-length (elements-slot tensor1)) :initial-contents (elements-slot tensor1)))
							(a2 (make-array (list-length (elements-slot tensor2)) :initial-contents (elements-slot tensor2)))
								(l1 '()))
							(dotimes (i (array-dimension a1 0))
								(if (>= (aref a1 i) (aref a2 i))
									(setf l1 (append l1 (list 1)))
									(setf l1 (append l1 (list 0)))
								)
							)
							(setf (elements-slot tAux) l1))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.>= (make-instance 'tensorClass
																  :elements (car (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (car (elements-slot tensor2)))))
								(elements-slot (.>= (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor2)))))))
				)
			)
		tAux)
		;;tensor1 is a scalar
		(if (equal (size-slot tensor1) '(1))
			(let ((tAux (make-instance 'tensorClass :size (size-slot tensor2)))
				(lAux '()))
			 (if (equal (elements-slot tAux) '())
				 '()
				 (if (not(listp (car (elements-slot tensor1))))
					(progn
						(dolist (el (elements-slot tensor2))
								(if (>= (car (elements-slot tensor1)) el)
									(setf el 1)
									(setf el 0)
								)
							(setf lAux (append lAux (list el))))

						(setf (elements-slot tAux) lAux))

					(setf (elements-slot tAux)
						  (cons (elements-slot (.>= tensor1 (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor2)))))
								(elements-slot (.>= tensor1 (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2)))))))
				))
			tAux)
			;;tensor2 is a scalar
			(if (equal (size-slot tensor2) '(1))
				(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1)))
				(lAux '()))
				(if (equal (elements-slot tAux) '())
					'()
					(if (not(listp (car (elements-slot tensor2))))
						(progn
							(dolist (el (elements-slot tensor1))
								(if (>= el (car(elements-slot tensor2)))
									(setf el 1 )
									(setf el 0)
								)
								(setf lAux (append lAux (list el))))

						(setf (elements-slot tAux) lAux))

					(setf (elements-slot tAux)
						(cons (elements-slot (.>= (make-instance 'tensorClass
																	:elements (car (elements-slot tensor1))) tensor2))
								(elements-slot (.>= (make-instance 'tensorClass
																:elements (cdr (elements-slot tensor2))) tensor2))))
					))
				tAux)
		)))
)

(defmethod .<= ((tensor1 tensorClass) (tensor2 tensorClass))
	;;tensors have the same size
	(if (equal (size-slot tensor1)
			   (size-slot tensor2))
		(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1))))
			 (if (equal (elements-slot tensor1) '())
				'()
				(if (not (and (listp (car (elements-slot tensor1)))
							  (listp (car (elements-slot tensor2)))))
					(let ((a1 (make-array (list-length (elements-slot tensor1)) :initial-contents (elements-slot tensor1)))
							(a2 (make-array (list-length (elements-slot tensor2)) :initial-contents (elements-slot tensor2)))
								(l1 '()))
							(dotimes (i (array-dimension a1 0))
								(if (<= (aref a1 i) (aref a2 i))
									(setf l1 (append l1 (list 1)))
									(setf l1 (append l1 (list 0)))
								)
							)
							(setf (elements-slot tAux) l1))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.<= (make-instance 'tensorClass
																  :elements (car (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (car (elements-slot tensor2)))))
								(elements-slot (.<= (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor2)))))))
				)
			)
		tAux)
		;;tensor1 is a scalar
		(if (equal (size-slot tensor1) '(1))
			(let ((tAux (make-instance 'tensorClass :size (size-slot tensor2)))
				(lAux '()))
			 (if (equal (elements-slot tAux) '())
				 '()
				 (if (not(listp (car (elements-slot tensor1))))
					(progn
						(dolist (el (elements-slot tensor2))
								(if (<= (car (elements-slot tensor1)) el)
									(setf el 1)
									(setf el 0)
								)
							(setf lAux (append lAux (list el))))

						(setf (elements-slot tAux) lAux))

					(setf (elements-slot tAux)
						  (cons (elements-slot (.<= tensor1 (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor2)))))
								(elements-slot (.<= tensor1 (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2)))))))
				))
			tAux)
			;;tensor2 is a scalar
			(if (equal (size-slot tensor2) '(1))
				(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1)))
				(lAux '()))
				(if (equal (elements-slot tAux) '())
					'()
					(if (not(listp (car (elements-slot tensor2))))
						(progn
							(dolist (el (elements-slot tensor1))
								(if (<= el (car(elements-slot tensor2)))
									(setf el 1 )
									(setf el 0)
								)
								(setf lAux (append lAux (list el))))

						(setf (elements-slot tAux) lAux))

					(setf (elements-slot tAux)
						(cons (elements-slot (.<= (make-instance 'tensorClass
																	:elements (car (elements-slot tensor1))) tensor2))
								(elements-slot (.<= (make-instance 'tensorClass
																:elements (cdr (elements-slot tensor2))) tensor2))))
					))
				tAux)
		)))
)

(defmethod .= ((tensor1 tensorClass) (tensor2 tensorClass))
	;;tensors have the same size
	(if (equal (size-slot tensor1)
			   (size-slot tensor2))
		(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1))))
			 (if (equal (elements-slot tensor1) '())
				'()
				(if (not (and (listp (car (elements-slot tensor1)))
							  (listp (car (elements-slot tensor2)))))
					(let ((a1 (make-array (list-length (elements-slot tensor1)) :initial-contents (elements-slot tensor1)))
							(a2 (make-array (list-length (elements-slot tensor2)) :initial-contents (elements-slot tensor2)))
								(l1 '()))
							(dotimes (i (array-dimension a1 0))
								(if (= (aref a1 i) (aref a2 i))
									(setf l1 (append l1 (list 1)))
									(setf l1 (append l1 (list 0)))
								)
							)
							(setf (elements-slot tAux) l1))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.= (make-instance 'tensorClass
																  :elements (car (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (car (elements-slot tensor2)))))
								(elements-slot (.= (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor2)))))))
				)
			)
		tAux)
		;;tensor1 is a scalar
		(if (equal (size-slot tensor1) '(1))
			(let ((tAux (make-instance 'tensorClass :size (size-slot tensor2)))
				(lAux '()))
			 (if (equal (elements-slot tAux) '())
				 '()
				 (if (not(listp (car (elements-slot tensor1))))
					(progn
						(dolist (el (elements-slot tensor2))
								(if (= (car (elements-slot tensor1)) el)
									(setf el 1)
									(setf el 0)
								)
							(setf lAux (append lAux (list el))))

						(setf (elements-slot tAux) lAux))

					(setf (elements-slot tAux)
						  (cons (elements-slot (.= tensor1 (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor2)))))
								(elements-slot (.= tensor1 (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2)))))))
				))
			tAux)
			;;tensor2 is a scalar
			(if (equal (size-slot tensor2) '(1))
				(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1)))
				(lAux '()))
				(if (equal (elements-slot tAux) '())
					'()
					(if (not(listp (car (elements-slot tensor2))))
						(progn
							(dolist (el (elements-slot tensor1))
								(if (= el (car(elements-slot tensor2)))
									(setf el 1 )
									(setf el 0)
								)
								(setf lAux (append lAux (list el))))

						(setf (elements-slot tAux) lAux))

					(setf (elements-slot tAux)
						(cons (elements-slot (.= (make-instance 'tensorClass
																	:elements (car (elements-slot tensor1))) tensor2))
								(elements-slot (.= (make-instance 'tensorClass
																:elements (cdr (elements-slot tensor2))) tensor2))))
					))
				tAux)
		)))
)

(defmethod .or ((tensor1 tensorClass) (tensor2 tensorClass))
	;;tensors have the same size
	(if (equal (size-slot tensor1)
			   (size-slot tensor2))
		(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1))))
			 (if (equal (elements-slot tensor1) '())
				'()
				(if (not (and (listp (car (elements-slot tensor1)))
							  (listp (car (elements-slot tensor2)))))
					(let ((a1 (make-array (list-length (elements-slot tensor1)) :initial-contents (elements-slot tensor1)))
							(a2 (make-array (list-length (elements-slot tensor2)) :initial-contents (elements-slot tensor2)))
								(l1 '()))
							(dotimes (i (array-dimension a1 0))
								(if (and (zerop (aref a1)) (zerop (aref a2)))
										(setf l1 (append l1 (list 0)))
									(setf l1 (append l1 (list 1)))
								)
							)
							(setf (elements-slot tAux) l1))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.or (make-instance 'tensorClass
																  :elements (car (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (car (elements-slot tensor2)))))
								(elements-slot (.or (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor2)))))))
				)
			)
		tAux)
		;;tensor1 is a scalar
		(if (equal (size-slot tensor1) '(1))
			(let ((tAux (make-instance 'tensorClass :size (size-slot tensor2)))
				(lAux '()))
			 (if (equal (elements-slot tAux) '())
				 '()
				 (if (not(listp (car (elements-slot tensor1))))
					(progn
						(dolist (el (elements-slot tensor2))
							(if (and (zerop (car (elements-slot tensor1))) (zerop el))
										(setf lAux (append lAux (list 0)))
									(setf lAux (append lAux (list 1)))
							)
						)
						(setf (elements-slot tAux) lAux))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.or tensor1 (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor2)))))
								(elements-slot (.or tensor1 (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2)))))))
				))
			tAux)
			;;tensor2 is a scalar
			(if (equal (size-slot tensor2) '(1))
				(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1)))
						(lAux '()))
					 (if (equal (elements-slot tAux) '())
						'()
						(if (not(listp (car (elements-slot tensor2))))
							(progn
								(dolist (el (elements-slot tensor1))
									(if (and (zerop el) (zerop (car (elements-slot tensor2))))
										(setf lAux (append lAux (list 0)))
									(setf lAux (append lAux (list 1)))
									)
								)
								(setf (elements-slot tAux) lAux))
							(setf (elements-slot tAux)
								  (cons (elements-slot (.or (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor1))) tensor2))
										(elements-slot (.or (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2))) tensor2))))
						)
					)
				tAux)
		)))
)

(defmethod .and ((tensor1 tensorClass) (tensor2 tensorClass))
	;;tensors have the same size
	(if (equal (size-slot tensor1)
			   (size-slot tensor2))
		(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1))))
			 (if (equal (elements-slot tensor1) '())
				'()
				(if (not (and (listp (car (elements-slot tensor1)))
							  (listp (car (elements-slot tensor2)))))
					(let ((a1 (make-array (list-length (elements-slot tensor1)) :initial-contents (elements-slot tensor1)))
							(a2 (make-array (list-length (elements-slot tensor2)) :initial-contents (elements-slot tensor2)))
								(l1 '()))
							(dotimes (i (array-dimension a1 0))
								(if (and (= 1 (aref a1)) (= 1 (aref a2)))
										(setf l1 (append l1 (list 1)))
									(setf l1 (append l1 (list 0)))
								)
							)
							(setf (elements-slot tAux) l1))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.and (make-instance 'tensorClass
																  :elements (car (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (car (elements-slot tensor2)))))
								(elements-slot (.and (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor1)))
												   (make-instance 'tensorClass
																  :elements (cdr (elements-slot tensor2)))))))
				)
			)
		tAux)
		;;tensor1 is a scalar
		(if (equal (size-slot tensor1) '(1))
			(let ((tAux (make-instance 'tensorClass :size (size-slot tensor2)))
				(lAux '()))
			 (if (equal (elements-slot tAux) '())
				 '()
				 (if (not(listp (car (elements-slot tensor1))))
					(progn
						(dolist (el (elements-slot tensor2))
							(if (and (= 1 (car (elements-slot tensor1))) (= 1 el))
										(setf lAux (append lAux (list 1)))
									(setf lAux (append lAux (list 0)))
							)
						)
						(setf (elements-slot tAux) lAux))
					(setf (elements-slot tAux)
						  (cons (elements-slot (.and tensor1 (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor2)))))
								(elements-slot (.and tensor1 (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2)))))))
				))
			tAux)
			;;tensor2 is a scalar
			(if (equal (size-slot tensor2) '(1))
				(let ((tAux (make-instance 'tensorClass :size (size-slot tensor1)))
						(lAux '()))
					 (if (equal (elements-slot tAux) '())
						'()
						(if (not(listp (car (elements-slot tensor2))))
							(progn
								(dolist (el (elements-slot tensor1))
									(if (and (= 1 el) (= 1 (car (elements-slot tensor2))))
										(setf lAux (append lAux (list 1)))
									(setf lAux (append lAux (list 0)))
									)
								)
								(setf (elements-slot tAux) lAux))
							(setf (elements-slot tAux)
								  (cons (elements-slot (.and (make-instance 'tensorClass
																		  :elements (car (elements-slot tensor1))) tensor2))
										(elements-slot (.and (make-instance 'tensorClass
																		  :elements (cdr (elements-slot tensor2))) tensor2))))
						)
					)
				tAux)
		)))
)