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
