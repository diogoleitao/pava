(defun factorial (n)
	(if (= n 0) 1
		(* n (factorial (- n 1)))))

(dolist (i lst)
		(setf lAux (append lAux (list (factorial i))))
lAux)



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


(defmethod .! ((obj tensor))
	(let ((iter (make-array (list-length (size-slot tensor))
							:initial-contents (size-slot tensor))))
		(dotimes (i (- 1 (array-dimension iter 0)))
			(dotimes (j (aref iter i))
				(factorialList (aref ))
			)
		)
	)
)

(defmethod .sin((obj tensor))
	(if (= 1 (slot-value tensor 'size))
		(let ((tAux (make-instance 'scalarClass)))
			(setf (slot-value tAux 'elements) (sin (first (slot-value tensor 'elements))))
		tAux)
		(let ((tAux (make-instance 'vectorClass)
					:size (size-slot tensor)))
			(setf (slot-value tAux 'elements)
				  (.sin (elements-slot tensor)))
		tAux)
)




















(defmethod .! ((obj tensor))
    (if (= 1 (slot-value tensor 'size))
		(let ((tAux (make-instance 'scalarClass)))
			(setf (slot-value tAux 'elements) (factorial (first (slot-value tensor 'elements))))
		tAux)
		(let ((tAux (make-instance 'vectorClass :size (slot-value tensor 'size))))

			(setf (slot-value tAux 'elements) (factorialList (slot-value tensor 'elements)))
		tAux)
))



































