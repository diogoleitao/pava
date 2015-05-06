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

;; Tensor (of numbers) and booleans representation
;; Note: true is 1 and false is 0
(defun tensor(dim values)
	(make-array dim :initial-contents values))

;; Scalar and vector creation
;; e.g.: (s 2) prints out 2 and
;; 		 (v 1 2 3) prints out 1 2 3
(defun s(scalar)
	(tensor (list 1) (list scalar)))
	
(defun v(&rest values)
	   (tensor (list 1) (list values)))

(defgeneric .- ())	

(defgeneric ./ ())

;;Monadic Functions - functions that receive only one argument

;;@Leitao - estive a pensar nisto e se calhar com recursao conseguimos fazer sem usar o for mas ainda nai sei bem como..
;;			tipo o caso de paragem e quando o scalar=1 e depois chamavamos uma funcao recursiva que adiciona ao vector sempre scalar -1 no inicio ate chegar a 1
;;			so nao sei como fazer a parte de criar o vector e nao sei de todo se esta e uma boa abordagem lol
(defun interval(scalar))


(defun drop(elements))

(defun reshape(dimensions tensor))

(defun outer-product(function))

(defun inner-product(func1 func2))

(defun fold(function))

(defmethod .- ())

(defmethod ./ ())

(defun .! (tensor)
  (let ((tAux (tensor (array-dimensions tensor) val)))
		(dotimes (i (array-dimension tensor 0))
			(setf (aref tAux) (factorial (aref tensor i))))
	tAux))

(defun .sin (tensor)
	(let ((tAux (tensor (array-dimensions tensor) val)))
		(dotimes (i (array-dimension tensor 0))
			(setf (aref tAux i) (cos (aref tensor i))))
	tAux))

(defun .cos (tensor)
	(let ((tAux (tensor (array-dimensions tensor) val)))
		(dotimes (i (array-dimension tensor 0))
			(setf (aref tAux i) (sin (aref tensor i))))
	tAux))

;; The result is a tensor containing, as elements, the integers 0 or 1 if the element of the given tensor is different than zero or equal
(defun .not (tensor)
		(let ((tAux (tensor (array-dimensions tensor) val)))
		(dotimes (i (array-dimension tensor 0))
			(if (= (aref tensor i) 0)
				(setf (aref tAux i) 1)
				(setf (aref tAux i) 0)))
	tAux))

;;Dyadic functions - functions that receive two arguments

(defun catenate(arg1 arg2))

(defun member?(tensor element))

(defun select(tensor tensor))

(defun scan(tensor tensor))

;;For the following functions the test cases are:
;; 1- The tensors have the same size. The auxiliary tensor always has the size of tensor1
;; 2- Tensor1 is a scalar, so the auxiliary tensor has the size of tensor2
;; 3- Tensor2 is a scalar, so the auxiliary tensor has the size of tensor1
;; else an error is returned because the sizes are incompatible

(defun .+ (tensor1 tensor2)
	(if (= (array-dimensions tensor1) (array-dimensions tensor2))
		(let ((tAux (tensor (array-dimensions tensor1) val)))
			(dotimes (i (array-dimension tensor1 0))
				(setf (aref tAux i) (+ (aref tensor1 i) (aref tensor2 i)))) tAux)
			
		(if ((= (array-dimension tensor1 0) 1))
			(let ((tAux (tensor (array-dimensions tensor2) val)))
				(dotimes (i (array-dimension tensor2 0))
					(setf (aref tAux i) (+ tensor1 (aref tensor2 i)))) tAux)
					
			(if ((= (array-dimension tensor2 0) 1))
				(let ((tAux (tensor (array-dimensions tensor1) val)))
					(dotimes (i (array-dimension tensor1 0))
						(setf (aref tAux i) (+ tensor2 (aref tensor1 i)))) tAux)))
	
		(error "Tensors have incompatible dimensions -- .+"))
)

(defmethod .- ())

(defmethod ./ ())

(defun .* (tensor1 tensor2)
	(if (= (array-dimensions tensor1) (array-dimensions tensor2))
			(let ((tAux (tensor (array-dimensions tensor1) val)))
				(dotimes (i (array-dimension tensor1 0))
					(setf (aref tAux i) (* (aref tensor1 i) (aref tensor2 i)))) tAux)

			(if ((= (array-dimension tensor1 0) 1))
				(let ((tAux (tensor (array-dimensions tensor2) val)))
					(dotimes (i (array-dimension tensor2 0))
						(setf (aref tAux i) (* tensor1 (aref tensor2 i)))) tAux)

				(if ((= (array-dimension tensor2 0) 1))
					(let ((tAux (tensor (array-dimensions tensor1) val)))
						(dotimes (i (array-dimension tensor1 0))
							(setf (aref tAux i) (* tensor2 (aref tensor1 i)))) tAux)))

		(error "Tensors have incompatible dimensions -- .*"))
)

(defun .// (tensor1 tensor2)
	(if (= (array-dimensions tensor1) (array-dimensions tensor2))
			(let ((tAux (tensor (array-dimensions tensor1) val)))
				(dotimes (i (array-dimension tensor1 0))
					(setf (aref tAux i) (// (aref tensor1 i) (aref tensor2 i)))) tAux)

			(if ((= (array-dimension tensor1 0) 1))
				(let ((tAux (tensor (array-dimensions tensor2) val)))
					(dotimes (i (array-dimension tensor2 0))
						(setf (aref tAux i) (// tensor1 (aref tensor2 i)))) tAux)

				(if ((= (array-dimension tensor2 0) 1))
					(let ((tAux (tensor (array-dimensions tensor1) val)))
						(dotimes (i (array-dimension tensor1 0))
							(setf (aref tAux i) (// tensor2 (aref tensor1 i)))) tAux)))

		(error "Tensors have incompatible dimensions -- .//"))
)

(defun .% (tensor1 tensor2)
	(if (= (array-dimensions tensor1) (array-dimensions tensor2))
			(let ((tAux (tensor (array-dimensions tensor1) val)))
				(dotimes (i (array-dimension tensor1 0))
					(setf (aref tAux i) (% (aref tensor1 i) (aref tensor2 i)))) tAux)

			(if ((= (array-dimension tensor1 0) 1))
				(let ((tAux (tensor (array-dimensions tensor2) val)))
					(dotimes (i (array-dimension tensor2 0))
						(setf (aref tAux i) (% tensor1 (aref tensor2 i)))) tAux)

				(if ((= (array-dimension tensor2 0) 1))
					(let ((tAux (tensor (array-dimensions tensor1) val)))
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
	(if (= (array-dimensions tensor1) (array-dimensions tensor2))
		(let ((tAux (tensor (array-dimensions tensor1) val)))
			(dotimes (i (array-dimension tensor1 0))
				(if (> (aref tensor1 i) (aref tensor2 i))
					(setf (aref tAux i) 1)
					(setf (aref tAux i) 0))) tAux)
		
		(if ((= (array-dimension tensor1 0) 1))
			(let ((tAux (tensor (array-dimensions tensor2) val)))
				(dotimes (i (array-dimension tensor2 0))
					(if (> tensor1 (aref tensor2 i))
						(setf (aref tAux i) 1)
						(setf (aref tAux i) 0))) tAux)
			
			(if ((= (array-dimension tensor2 0) 1))
				(let ((tAux (tensor (array-dimensions tensor1) val)))
					(dotimes (i (array-dimension tensor2 0))
						(if (> tensor2 (aref tensor1 i))
							(setf (aref tAux i) 1)
							(setf (aref tAux i) 0))) tAux)))
		
		(error "Tensors have incompatible dimensions --.>"))
)

(defun .< (tensor1 tensor2)
	(if (= (array-dimensions tensor1) (array-dimensions tensor2))
		(let ((tAux (tensor (array-dimensions tensor1) val)))
			(dotimes (i (array-dimension tensor1 0))
				(if (< (aref tensor1 i) (aref tensor2 i))
					(setf (aref tAux i) 1)
					(setf (aref tAux i) 0))) tAux)
		
		(if ((= (array-dimension tensor1 0) 1))
			(let ((tAux (tensor (array-dimensions tensor2) val)))
				(dotimes (i (array-dimension tensor2 0))
					(if (< tensor1 (aref tensor2 i))
						(setf (aref tAux i) 1)
						(setf (aref tAux i) 0))) tAux)
			
			(if ((= (array-dimension tensor2 0) 1))
				(let ((tAux (tensor (array-dimensions tensor1) val)))
					(dotimes (i (array-dimension tensor2 0))
						(if (< tensor2 (aref tensor1 i))
							(setf (aref tAux i) 1)
							(setf (aref tAux i) 0))) tAux)))
		
		(error "Tensors have incompatible dimensions --.<"))
)

(defun .>= (tensor1 tensor2)
	(if (= (array-dimensions tensor1) (array-dimensions tensor2))
		(let ((tAux (tensor (array-dimensions tensor1) val)))
			(dotimes (i (array-dimension tensor1 0))
				(if (>= (aref tensor1 i) (aref tensor2 i))
					(setf (aref tAux i) 1)
					(setf (aref tAux i) 0))) tAux)

		(if ((= (array-dimension tensor1 0) 1))
			(let ((tAux (tensor (array-dimensions tensor2) val)))
				(dotimes (i (array-dimension tensor2 0))
					(if (>= tensor1 (aref tensor2 i))
						(setf (aref tAux i) 1)
						(setf (aref tAux i) 0))) tAux)

			(if ((= (array-dimension tensor2 0) 1))
				(let ((tAux (tensor (array-dimensions tensor1) val)))
					(dotimes (i (array-dimension tensor2 0))
						(if (>= tensor2 (aref tensor1 i))
							(setf (aref tAux i) 1)
							(setf (aref tAux i) 0))) tAux)))

		(error "Tensors have incompatible dimensions --.>="))
)

(defun .<= (tensor1 tensor2)
	(if (= (array-dimensions tensor1) (array-dimensions tensor2))
		(let ((tAux (tensor (array-dimensions tensor1) val)))
			(dotimes (i (array-dimension tensor1 0))
				(if (<= (aref tensor1 i) (aref tensor2 i))
					(setf (aref tAux i) 1)
					(setf (aref tAux i) 0))) tAux)

		(if ((= (array-dimension tensor1 0) 1))
			(let ((tAux (tensor (array-dimensions tensor2) val)))
				(dotimes (i (array-dimension tensor2 0))
					(if (<= tensor1 (aref tensor2 i))
						(setf (aref tAux i) 1)
						(setf (aref tAux i) 0))) tAux)

			(if ((= (array-dimension tensor2 0) 1))
				(let ((tAux (tensor (array-dimensions tensor1) val)))
					(dotimes (i (array-dimension tensor2 0))
						(if (<= tensor2 (aref tensor1 i))
							(setf (aref tAux i) 1)
							(setf (aref tAux i) 0))) tAux)))

		(error "Tensors have incompatible dimensions --.<="))
)

(defun .= (tensor1 tensor2)
	(if (= (array-dimensions tensor1) (array-dimensions tensor2))
		(let ((tAux (tensor (array-dimensions tensor1) val)))
			(dotimes (i (array-dimension tensor1 0))
				(if (= (aref tensor1 i) (aref tensor2 i))
					(setf (aref tAux i) 1)
					(setf (aref tAux i) 0))) tAux)

		(if ((= (array-dimension tensor1 0) 1))
			(let ((tAux (tensor (array-dimensions tensor2) val)))
				(dotimes (i (array-dimension tensor2 0))
					(if (= tensor1 (aref tensor2 i))
						(setf (aref tAux i) 1)
						(setf (aref tAux i) 0))) tAux)

			(if ((= (array-dimension tensor2 0) 1))
				(let ((tAux (tensor (array-dimensions tensor1) val)))
					(dotimes (i (array-dimension tensor2 0))
						(if (= tensor2 (aref tensor1 i))
							(setf (aref tAux i) 1)
							(setf (aref tAux i) 0))) tAux)))

		(error "Tensors have incompatible dimensions --.="))
)

(defun .or (tensor1 tensor2)
	(if (= (array-dimensions tensor1) (array-dimensions tensor2))
		(let ((tAux (tensor (array-dimensions tensor1) val)))
			(dotimes (i (array-dimension tensor1 0))
				(if (or (aref tensor1 i) (aref tensor2 i))
					(setf (aref tAux i) 1)
					(setf (aref tAux i) 0))) tAux)

		(if ((= (array-dimension tensor1 0) 1))
			(let ((tAux (tensor (array-dimensions tensor2) val)))
				(dotimes (i (array-dimension tensor2 0))
					(if (or tensor1 (aref tensor2 i))
						(setf (aref tAux i) 1)
						(setf (aref tAux i) 0))) tAux)

			(if ((= (array-dimension tensor2 0) 1))
				(let ((tAux (tensor (array-dimensions tensor1) val)))
					(dotimes (i (array-dimension tensor2 0))
						(if (or tensor2 (aref tensor1 i))
							(setf (aref tAux i) 1)
							(setf (aref tAux i) 0))) tAux)))

		(error "Tensors have incompatible dimensions --.or"))
)

(defun .and (tensor tensor2)
	(if (= (array-dimensions tensor1) (array-dimensions tensor2))
		(let ((tAux (tensor (array-dimensions tensor1) val)))
			(dotimes (i (array-dimension tensor1 0))
				(if (and (aref tensor1 i) (aref tensor2 i))
					(setf (aref tAux i) 1)
					(setf (aref tAux i) 0))) tAux)

		(if ((= (array-dimension tensor1 0) 1))
			(let ((tAux (tensor (array-dimensions tensor2) val)))
				(dotimes (i (array-dimension tensor2 0))
					(if (and tensor1 (aref tensor2 i))
						(setf (aref tAux i) 1)
						(setf (aref tAux i) 0))) tAux)

			(if ((= (array-dimension tensor2 0) 1))
				(let ((tAux (tensor (array-dimensions tensor1) val)))
					(dotimes (i (array-dimension tensor2 0))
						(if (and tensor2 (aref tensor1 i))
							(setf (aref tAux i) 1)
							(setf (aref tAux i) 0))) tAux)))

		(error "Tensors have incompatible dimensions --.and"))
)
