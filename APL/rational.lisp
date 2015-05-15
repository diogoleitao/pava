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

(defun s(scalar)
	(make-instance 'scalarClass
				   :elements (list scalar)))

(defun v(&rest vals)
	(make-instance 'vectorClass
				   :elements vals
				   :size (list (list-length vals))))

(defmethod print-object((obj tensorClass) out)
	(if (not (equal (elements-slot obj) '()))
		(if (not (listp (car (elements-slot obj))))
			(dolist (el (elements-slot obj))
				(format out "~D " el))
			(progn
				(print-object (make-instance 'tensorClass :elements (car (elements-slot obj))) out)
				(pprint-newline :mandatory out)
				(if (not (listp (cdr (elements-slot obj))))
					(dolist (el (elements-slot obj))
						(format out "~D " el))
					(print-object (make-instance 'tensorClass :elements (cdr (elements-slot obj))) out)))
		)
	)
)

