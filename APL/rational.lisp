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
	(print-unreadable-object (obj out :type t)
		(print (elements-slot obj))
	)
)

(defmethod drop ((n scalarClass) (tsr tensorClass))
	(let ((lAux '())
			(tAux (make-instance 'tensorClass)))
		 (if (equal (elements-slot tsr) '())
			 '()
			 (if (not (equal (car (elements-slot tsr)) '()))
				 (if (not (listp (car (elements-slot tsr))))
					 (let ((aAux (make-array (list-length (elements-slot tsr)) :initial-contents (elements-slot tsr))))
						  (if (< (car (elements-slot n)) 0)
							  (progn
								  (dotimes (i (- (array-dimension aAux 0) (abs (car (elements-slot n)))))
										(setf lAux (append lAux (list (aref aAux (+ i (abs (car (elements-slot n)))))))))
								  (setf (elements-slot tAux) lAux))
							  (progn
								  (dotimes (i (- (array-dimension aAux 0) (car (elements-slot n))))
										(setf lAux (append lAux (list (aref aAux i)))))
								  (setf (elements-slot tAux) lAux))))
					 (setf lAux (append lAux (drop n (make-instance 'tensorClass :elements (cdr (elements-slot tsr)))))))
				 (setf lAux
					   (cons (elements-slot (drop n (make-instance 'tensorClass :elements (car (elements-slot tsr)))))
							 (elements-slot (drop n (make-instance 'tensorClass :elements (cdr (elements-slot tsr)))))))))
	tAux)
)
























