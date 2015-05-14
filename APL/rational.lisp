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

(defmethod print-object((obj tensorClass) out)
	(print-unreadable-object (obj out :type t)
		(print (elements-slot obj))
	)
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
