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

;; TODO!
(defun print-tensor (tsr)
	(if (= 1 (array-rank tsr))
		(format t "")
	)
)

;; Tensor (of numbers) and booleans representation
;; Note: true is 1 and false is 0
(defun tensor (dim value)
	(make-array dim :initial-element value))

;;definition of the class tensor and acessor methods
(defclass tensor ()
	((dim :accessor tensor_dim)
	 (values :accessor tensor_values)
	)
)
(defmethod tensor_dim ((obj tensor))
  (slot-value obj 'dim))

(defmethod (setf tensor_dim) ((obj tensor) new-value)
  (setf (slot-value obj 'dim) new-value))

(defmethod tensor_values ((obj tensor))
  (slot-value obj 'values))

(defmethod (setf tensor_values) (new-value (obj tensor)) 
	(setf (slot-value obj 'tensor_values) new-value))

;; Scalar and vector creation
;; e.g.: (s 2) prints out 2 and
;; 		 (v 1 2 3) prints out 1 2 3
(defun s(scalar)
	(tensor (list 1) scalar))

(defclass scalar(tensor)
	((dim :accessor tensor_dim
		  :initform 0)
	 (values :type integer 
			 :accessor tensor_values)
	)
)

(defun v(&rest values)
	(tensor (list (list-length values)) values))

(defclass vector(tensor)
	((dim :accessor tensor_dim
		  :initform 1)
	 (values :type array
			 :accessor tensor_values)
	)
)

(defclass matrix(tensor)
	((dim :accessor tensor_dim
		  :initform 2)
	 (values :type array
			 :accessor tensor_values)
	)
)

(defgeneric .- (&rest values))

(defgeneric ./ (&rest values))

(defgeneric drop (t1 t1))

(defgeneric catenate(t1 t2))

;;Monadic Functions - functions that receive only one argument

(defun interval (scalar)
	(let ((tAux (tensor (list scalar) '())))
		 (dotimes (i (- scalar 1))
			(setf (aref tAux i)
				  (+ i 1)))
	tAux)
)

(defmethod drop ((scalar n) (tensor tsr))
	(let* ((new-dim (- (array-dimension tsr 0) n))
			((tAux (tensor (list new-dim) 0))))
		(if (> n 0)
			(dotimes (i new-dim)
				(setf (aref tAux i)
					  (aref tsr (+ i n))))
			(dotimes (i new-dim)
				(setf (aref tAux i)
					  (aref tsr i))))
	tAux)
)

(defmethod drop ((tensor tsr1) (tensor tsr2))
	(let ((tAux (tensor (list )))))
)

(defun reshape (dimensions tensor))

(defun outer-product (func))

(defun inner-product (func1 func2))

(defun fold (func))

(defmethod .- ())

(defmethod ./ ())

(defun .! (tensor)
  (let ((tAux (tensor (array-rank tensor) 0)))
		(dotimes (i (array-dimension tensor 0))
			(setf (aref tAux)
				  (factorial (aref tensor i))))
	tAux))

(defun .sin (tensor)
	(let ((tAux (tensor (array-rank tensor) 0)))
		(dotimes (i (array-dimension tensor 0))
			(setf (aref tAux i)
				  (cos (aref tensor i))))
	tAux))

(defun .cos (tensor)
	(let ((tAux (tensor (array-rank tensor) 0)))
		(dotimes (i (array-dimension tensor 0))
			(setf (aref tAux i)
				  (sin (aref tensor i))))
	tAux)
)

;; The result is a tensor containing, as elements, the integers 0 or 1 if the element of the given tensor is different than or equal to zero
(defun .not (tensor)
	(let ((tAux (tensor (array-rank tensor) 0)))
		(dotimes (i (array-dimension tensor 0))
			(if (= (aref tensor i) 0)
				(setf (aref tAux i) 1)
				(setf (aref tAux i) 0)))
	tAux)
)

;;Dyadic functions - functions that receive two arguments
(defmethod catenate ((scalar s1) (scalar s2))
	(v (list s1 s2))
)

(defmethod catenate ((tensor s1) (tensor s2))
	(let ((tAux (tensor  (list 0)))))
)

(defun member? (tensor element))

(defun select (tensor tensor))

(defun scan (tensor tensor))

;;For the following functions the test cases are:
;; 1- The tensors have the same size. The auxiliary tensor always has the size of tensor1
;; 2- Tensor1 is a scalar, so the auxiliary tensor has the size of tensor2
;; 3- Tensor2 is a scalar, so the auxiliary tensor has the size of tensor1
;; else an error is returned because the sizes are incompatible

(defun .+ (tensor1 tensor2)
	(if (= (array-rank tensor1) (array-rank tensor2))
		(let ((tAux (tensor (array-rank tensor1) 0)))
			(dotimes (i (array-dimension tensor1 0))
				(setf (aref tAux i) (+ (aref tensor1 i) (aref tensor2 i)))) tAux)
			
		(if ((= (array-dimension tensor1 0) 1))
			(let ((tAux (tensor (array-rank tensor2) 0)))
				(dotimes (i (array-dimension tensor2 0))
					(setf (aref tAux i) (+ tensor1 (aref tensor2 i)))) tAux)
					
			(if ((= (array-dimension tensor2 0) 1))
				(let ((tAux (tensor (array-rank tensor1) 0)))
					(dotimes (i (array-dimension tensor1 0))
						(setf (aref tAux i) (+ tensor2 (aref tensor1 i)))) tAux)))
	
		(error "Tensors have incompatible dimensions -- .+"))
)

(defmethod .- ())

(defmethod ./ ())

(defun .* (tensor1 tensor2)
	(if (= (array-rank tensor1) (array-rank tensor2))
			(let ((tAux (tensor (array-rank tensor1) 0)))
				(dotimes (i (array-dimension tensor1 0))
					(setf (aref tAux i) (* (aref tensor1 i) (aref tensor2 i)))) tAux)

			(if ((= (array-dimension tensor1 0) 1))
				(let ((tAux (tensor (array-rank tensor2) 0)))
					(dotimes (i (array-dimension tensor2 0))
						(setf (aref tAux i) (* tensor1 (aref tensor2 i)))) tAux)

				(if ((= (array-dimension tensor2 0) 1))
					(let ((tAux (tensor (array-rank tensor1) 0)))
						(dotimes (i (array-dimension tensor1 0))
							(setf (aref tAux i) (* tensor2 (aref tensor1 i)))) tAux)))

		(error "Tensors have incompatible dimensions -- .*"))
)

(defun .// (tensor1 tensor2)
	(if (= (array-rank tensor1) (array-rank tensor2))
			(let ((tAux (tensor (array-rank tensor1) 0)))
				(dotimes (i (array-dimension tensor1 0))
					(setf (aref tAux i) (// (aref tensor1 i) (aref tensor2 i)))) tAux)

			(if ((= (array-dimension tensor1 0) 1))
				(let ((tAux (tensor (array-rank tensor2) 0)))
					(dotimes (i (array-dimension tensor2 0))
						(setf (aref tAux i) (// tensor1 (aref tensor2 i)))) tAux)

				(if ((= (array-dimension tensor2 0) 1))
					(let ((tAux (tensor (array-rank tensor1) 0)))
						(dotimes (i (array-dimension tensor1 0))
							(setf (aref tAux i) (// tensor2 (aref tensor1 i)))) tAux)))

		(error "Tensors have incompatible dimensions -- .//"))
)

(defun .% (tensor1 tensor2)
	(if (= (array-rank tensor1) (array-rank tensor2))
			(let ((tAux (tensor (array-rank tensor1) 0)))
				(dotimes (i (array-dimension tensor1 0))
					(setf (aref tAux i) (% (aref tensor1 i) (aref tensor2 i)))) tAux)

			(if ((= (array-dimension tensor1 0) 1))
				(let ((tAux (tensor (array-rank tensor2) 0)))
					(dotimes (i (array-dimension tensor2 0))
						(setf (aref tAux i) (% tensor1 (aref tensor2 i)))) tAux)

				(if ((= (array-dimension tensor2 0) 1))
					(let ((tAux (tensor (array-rank tensor1) 0)))
						(dotimes (i (array-dimension tensor1 0))
							(setf (aref tAux i) (% tensor2 (aref tensor1 i)))) tAux)))

		(error "Tensors have incompatible dimensions -- .%"))
)

;;For the following functions the test cases are:
;; 1- The tensors have the same size. The auxiliary tensor always has the size of tensor1
;;		1.1 - for each element of the tensors a logical operation is performed, if T, tAux is filled with 1, otherwise with 0
;; 2- Tensor1 is a scalar, so the auxiliary tensor has the size of tensor2
;;		2.1 - for each element of tensor2 a logical operation is performed with tensor1, if T, tAux is filled with 1, otherwise with 0
;; 3- Tensor2 is a scalar, so the auxiliary tensor has the size of tensor1
;;		3.1 - for each element of tensor1 a logical operation is performed with tensor2, if T, tAux is filled with 1, otherwise with 0
;; else an error is returned because the sizes are incompatible
(defun .> (tensor1 tensor2)
	(if (= (array-rank tensor1) (array-rank tensor2))
		(let ((tAux (tensor (array-rank tensor1) 0)))
			(dotimes (i (array-dimension tensor1 0))
				(if (> (aref tensor1 i) (aref tensor2 i))
					(setf (aref tAux i) 1)
					(setf (aref tAux i) 0))) tAux)
		
		(if ((= (array-dimension tensor1 0) 1))
			(let ((tAux (tensor (array-rank tensor2) 0)))
				(dotimes (i (array-dimension tensor2 0))
					(if (> tensor1 (aref tensor2 i))
						(setf (aref tAux i) 1)
						(setf (aref tAux i) 0))) tAux)
			
			(if ((= (array-dimension tensor2 0) 1))
				(let ((tAux (tensor (array-rank tensor1) 0)))
					(dotimes (i (array-dimension tensor2 0))
						(if (> tensor2 (aref tensor1 i))
							(setf (aref tAux i) 1)
							(setf (aref tAux i) 0))) tAux)))
		
		(error "Tensors have incompatible dimensions --.>"))
)

(defun .< (tensor1 tensor2)
	(if (= (array-rank tensor1) (array-rank tensor2))
		(let ((tAux (tensor (array-rank tensor1) 0)))
			(dotimes (i (array-dimension tensor1 0))
				(if (< (aref tensor1 i) (aref tensor2 i))
					(setf (aref tAux i) 1)
					(setf (aref tAux i) 0))) tAux)
		
		(if ((= (array-dimension tensor1 0) 1))
			(let ((tAux (tensor (array-rank tensor2) 0)))
				(dotimes (i (array-dimension tensor2 0))
					(if (< tensor1 (aref tensor2 i))
						(setf (aref tAux i) 1)
						(setf (aref tAux i) 0))) tAux)
			
			(if ((= (array-dimension tensor2 0) 1))
				(let ((tAux (tensor (array-rank tensor1) 0)))
					(dotimes (i (array-dimension tensor2 0))
						(if (< tensor2 (aref tensor1 i))
							(setf (aref tAux i) 1)
							(setf (aref tAux i) 0))) tAux)))
		
		(error "Tensors have incompatible dimensions --.<"))
)

(defun .>= (tensor1 tensor2)
	(if (= (array-rank tensor1) (array-rank tensor2))
		(let ((tAux (tensor (array-rank tensor1) 0)))
			(dotimes (i (array-dimension tensor1 0))
				(if (>= (aref tensor1 i) (aref tensor2 i))
					(setf (aref tAux i) 1)
					(setf (aref tAux i) 0))) tAux)

		(if ((= (array-dimension tensor1 0) 1))
			(let ((tAux (tensor (array-rank tensor2) 0)))
				(dotimes (i (array-dimension tensor2 0))
					(if (>= tensor1 (aref tensor2 i))
						(setf (aref tAux i) 1)
						(setf (aref tAux i) 0))) tAux)

			(if ((= (array-dimension tensor2 0) 1))
				(let ((tAux (tensor (array-rank tensor1) 0)))
					(dotimes (i (array-dimension tensor2 0))
						(if (>= tensor2 (aref tensor1 i))
							(setf (aref tAux i) 1)
							(setf (aref tAux i) 0))) tAux)))

		(error "Tensors have incompatible dimensions --.>="))
)

(defun .<= (tensor1 tensor2)
	(if (= (array-rank tensor1) (array-rank tensor2))
		(let ((tAux (tensor (array-rank tensor1) 0)))
			(dotimes (i (array-dimension tensor1 0))
				(if (<= (aref tensor1 i) (aref tensor2 i))
					(setf (aref tAux i) 1)
					(setf (aref tAux i) 0)))
			tAux)

		(if ((= (array-dimension tensor1 0) 1))
			(let ((tAux (tensor (array-rank tensor2) 0)))
				(dotimes (i (array-dimension tensor2 0))
					(if (<= tensor1 (aref tensor2 i))
						(setf (aref tAux i) 1)
						(setf (aref tAux i) 0)))
				tAux)

			(if ((= (array-dimension tensor2 0) 1))
				(let ((tAux (tensor (array-rank tensor1) 0)))
					(dotimes (i (array-dimension tensor2 0))
						(if (<= tensor2 (aref tensor1 i))
							(setf (aref tAux i) 1)
							(setf (aref tAux i) 0)))
					tAux)))

		(error "Tensors have incompatible dimensions --.<="))
)

(defun .= (tensor1 tensor2)
	(if (= (array-rank tensor1) (array-rank tensor2))
		(let ((tAux (tensor (array-rank tensor1) 0)))
			(dotimes (i (array-dimension tensor1 0))
				(if (= (aref tensor1 i) (aref tensor2 i))
					(setf (aref tAux i) 1)
					(setf (aref tAux i) 0)))
			tAux)

		(if ((= (array-dimension tensor1 0) 1))
			(let ((tAux (tensor (array-rank tensor2) 0)))
				(dotimes (i (array-dimension tensor2 0))
					(if (= tensor1 (aref tensor2 i))
						(setf (aref tAux i) 1)
						(setf (aref tAux i) 0)))
				tAux)

			(if ((= (array-dimension tensor2 0) 1))
				(let ((tAux (tensor (array-rank tensor1) 0)))
					(dotimes (i (array-dimension tensor2 0))
						(if (= tensor2 (aref tensor1 i))
							(setf (aref tAux i) 1)
							(setf (aref tAux i) 0)))
					tAux)))

		(error "Tensors have incompatible dimensions --.="))
)

(defun .or (tensor1 tensor2)
	(if (= (array-rank tensor1) (array-rank tensor2))
		(let ((tAux (tensor (array-rank tensor1) 0)))
			(dotimes (i (array-dimension tensor1 0))
				(if (or (aref tensor1 i) (aref tensor2 i))
					(setf (aref tAux i) 1)
					(setf (aref tAux i) 0))) tAux)

		(if ((= (array-dimension tensor1 0) 1))
			(let ((tAux (tensor (array-rank tensor2) 0)))
				(dotimes (i (array-dimension tensor2 0))
					(if (or tensor1 (aref tensor2 i))
						(setf (aref tAux i) 1)
						(setf (aref tAux i) 0))) tAux)

			(if ((= (array-dimension tensor2 0) 1))
				(let ((tAux (tensor (array-rank tensor1) 0)))
					(dotimes (i (array-dimension tensor2 0))
						(if (or tensor2 (aref tensor1 i))
							(setf (aref tAux i) 1)
							(setf (aref tAux i) 0))) tAux)))

		(error "Tensors have incompatible dimensions --.or"))
)

(defun .and (tensor tensor2)
	(if (= (array-rank tensor1) (array-rank tensor2))
		(let ((tAux (tensor (array-rank tensor1) 0)))
			(dotimes (i (array-dimension tensor1 0))
				(if (and (aref tensor1 i) (aref tensor2 i))
					(setf (aref tAux i) 1)
					(setf (aref tAux i) 0))) tAux)

		(if ((= (array-dimension tensor1 0) 1))
			(let ((tAux (tensor (array-rank tensor2) 0)))
				(dotimes (i (array-dimension tensor2 0))
					(if (and tensor1 (aref tensor2 i))
						(setf (aref tAux i) 1)
						(setf (aref tAux i) 0))) tAux)

			(if ((= (array-dimension tensor2 0) 1))
				(let ((tAux (tensor (array-rank tensor1) 0)))
					(dotimes (i (array-dimension tensor2 0))
						(if (and tensor2 (aref tensor1 i))
							(setf (aref tAux i) 1)
							(setf (aref tAux i) 0))) tAux)))

		(error "Tensors have incompatible dimensions --.and"))
)
