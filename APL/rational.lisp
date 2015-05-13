(defun .!((obj tensor))
	(if ((not (listp (car (elements-slot tensor)))))
		(let ((tAux ...))
			 (dolist (el (elements-slot tensor))
				(setf el (factorial el))
			)
		)
		(append (.! (cadr (elements-slot tensor)))
				(.! (caddr (elements-slot tensor))))
	)
)