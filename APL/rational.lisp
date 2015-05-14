(defun factorial (n)
	(if (= n 0) 1
		(* n (factorial (- n 1)))))

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

(defclass vectorClass (tensorClass)
	((elements :type list
		   :initform '()
		   :initarg :elements)
	  (size :type list
			:initform '()
			:initarg :size)
	)
)

(defun v(&rest vals)
	(make-instance 'vectorClass
				   :elements vals
				   :size (list (list-length vals))))

(defmethod print-object((obj tensorClass) out)
	(print-unreadable-object (obj out :type t)
		(print (elements-slot obj))
	)
)

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
									(setf el 0)
								)
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
									(setf el 0)
								)
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