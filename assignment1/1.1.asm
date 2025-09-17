# $s0 = n
# $s1 = base address of array1
# $s2 = base address of array2
# $s3 = result

.data
	# Define initial variables like the length of the arrays and both vectors
	n: .word 5
	array1: .word 10, 20, 30, 40, 50
	array2: .word 60, 70, 80, 90, 100
	 

.text
	la $t0, n  # load the address of n from memory to a register
	lw $s0, 0($t0)  # load the value stored at the address of $t0 into register $s0
	
	la $s1, array1  # base address for array1
	la $s2, array2  # base address for array2
	
	add $s3, $zero, $zero  # register containing the result of the dot product
	
	add $t0, $zero, $zero  # define iteration variable (like i)
	
	loop:  # loop iterate over the n (number of elements in each vector)
		addi $t0, $t0, 1  # i++
		add $t1, $zero, $zero  # define a variable to store the value of the iteration to calculate the offset
		add $t2, $zero, $zero  # define iteration variable for offset (like j)
		
		offset_loop:  # loop multiplies offset by 4
			addi $t2, $t2, 1
			add $t1, $t1, $t0
			blt $t2, 4, offset_loop
		
		add $t3, $s1, $t1  # address of the current element of the array1
		add $t4, $s2, $t1  # address of the current element of the array2
		add $t2, $zero, $zero
		
		
		inner_loop:
			addi $t2, $t2, 1
			add $s3, $t5, $t3
			blt $t2, $t4, inner_loop 
		
		blt $t0, $s0, loop
	
	li $v0, 10
	syscall
	