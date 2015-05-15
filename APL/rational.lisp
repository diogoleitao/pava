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

(defun v(&rest vals)
	(make-instance 'vectorClass
				   :elements vals
				   :size (list (list-length vals))))

(defmethod print-object((obj tensorClass) out)
	(print-unreadable-object (obj out :type t)
		(print (elements-slot obj))
	)
)

(defgeneric catenate (tensorClass scalarClass))

(defmethod catenate ((scalar1 scalarClass) (scalar2 scalarClass))
	(let ((vAux (make-instance 'vectorClass)))
			(setf (elements-slot vAux)
				  (append (elements-slot scalar1)
						  (elements-slot scalar2)))
		vAux
	)
)

(defmethod catenate ((tensor1 tensorClass) (tensor2 tensorClass))
		(let ((lAux '())
				(tAux (make-instance 'tensorClass)))
					(if (not (equal (car (elements-slot tensor1)) '()))
							(if(not (listp (car (elements-slot tensor1))))
									(dolist (el (elements-slot tensor1))
											(setf lAux (append lAux (list el)))
									)
								(setf lAux (append lAux (catenate (make-instance 'tensorClass :elements (car (elements-slot tensor1)))
																	  (make-instance 'tensorClass :elements (cdr (elements-slot tensor1))))))
							)
						(if (not (equal (car (elements-slot tensor2)) '()))
							(if (not (listp (car (elements-slot tensor2))))
									 (dolist (el (elements-slot tensor2))
											(setf lAux (append lAux (list el)))
									 )
								(setf lAux (append lAux (catenate (make-instance 'tensorClass :elements (car (elements-slot tensor2)))
																	  (make-instance 'tensorClass :elements (cdr (elements-slot tensor2))))))
							)
						)
					)
		(setf (elements-slot tAux) lAux)
		tAux)
)

(defmethod reshape ((tensor1 tensorClass)(tensor2 tensorClass))
	(let ((tAux (make-instance 'tensorClass :size (elements-slot tensor1)))
			(nEls 1)
			(aAux (make-array (car (size-slot tensor2))
							  :initial-contents (elements-slot tensor2)))
			(els '()))
		(dolist (el (elements-slot tensor1))
			(setf nEls (* el nEls))
		)
		(dotimes (i nEls)
			(setf els (append els (list (aref aAux (mod i (car (size-slot tensor2)))))))
		)
		(dolist (el (elements-slot tensor2))
			(dotimes (i el)

			)
		)
	)
)
