# $s0 = n
# $s1 = base address of vector1
# $s2 = base address of vector2
# $s3: value of the i'th element in vector1
# $s4: value of the i'th element in vector2

# $s7 = result

# $t2: address of the i'th element in vector1
# $t3: address of the i'th element in vector2

.data
	# Define initial variables like the length of the arrays and both vectors
	n: .word 5
	# Vector 1
	# vector2: .word 10, 20, 35, 50, 15, 8, 40, 25, 30, 70, 60, 10, 80, 25, 55, 45, 90, 20, 60, 75, 40, 85, 95, 15, 5, 30, 65, 70, 55, 85, 50, 35, 7, 20, 99, 42, 1, 62, 7, 18, 22, 9, 5, 32, 58, 48, 77, 68, 11, 29

	# Vector 2
	# vector1: .word -5, -8, -25, -45, -12, -60, -15, -33, -80, -5, -20, -1, -55, -30, -75, -52, -18, -9, -65, -44, -30, -82, -50, -4, -90, -10, -32, -72, -40, -88, -60, -15, -70, -28, -5, -99, -58, -38, -6, -16, -8, -2, -49, -71, -13, -88, -38, -9, -21, -3
	
	vector1: .word 1, 2, 3, 4, 5
	vector2: .word 6, 7, 8, 9, 10
	 

.text
.globl main

main:
	la $t0, n  # load the address of n from memory to a register
	lw $s0, 0($t0)  # load the value stored at the address of $t0 into register $s0
	
	la $s1, vector1  # base address for vector1
	la $s2, vector2  # base address for vector2
	 
	add $t0, $zero, $zero  # define iteration variable (like i) to loop over vector1 elements.
	add $s7, $zero, $zero  # store value 0 in register $s7, which contains the result.
	
	##############
	add $t9, $zero, $zero
	##############
	
	main_loop:
		sll $t1, $t0, 2  # shift the value of i two bits. So $t1 = (i * 4)
		
		add $t2, $t1, $s1  # $t2: address of the i'th element in vector1
		lw $s3, 0($t2)  # $s3: value of the i'th element in vector1
		
		add $t3, $t1, $s2   # $t3: address of the i'th element in vector2
		lw $s4, 0($t3)  # $s4: value of the i'th element in vector2
		
		# REUSE $t1
		add $t1, $zero, $zero  # store the inner_loop iterator in $t1 (assume j)

		inner_loop:
			addi $t1, $t1, 1  # j++
			blt $s4, $zero, neg_cond  # if the i'th element of the vector2 is negative.
			add $s7, $s7, $s3  # add the value of the i'th element in vector1 to the result register
			blt $t1, $s4, inner_loop  # if j < n. If inner_loop iterator (j) < n then again add the i'th element of vector1 ($s3) the result register $s7.
			
			neg_cond:
				addi $t9, $t9, 1  # debug
				sub $t4, $zero, $s4  # $t4 contains the abs value of the $s4 (value of the i'th element in vector2)
				sub $s7, $s7, $s3  # if i'th element of the vector2 is negative, then subtract the i'th element of the vector1 from the result.
				blt $t1, $t4, inner_loop

		addi $t0, $t0, 1  # i++
		blt $t0, $s0, main_loop  # if i < n, then continue looping!
	
	li $v0, 10
	syscall  # exit the program.
	