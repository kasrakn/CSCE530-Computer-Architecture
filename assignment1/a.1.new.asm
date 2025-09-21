# $s0 = n (vector length)
# $s1 = base address of vector1
# $s2 = base address of vector2
# $s7 = dot product result
# $t0 = loop counter (i)
# $t1 = byte offset
# $t2 = address of element from vector1
# $t3 = address of element from vector2
# $t4 = value from vector1
# $t5 = value from vector2
# $t6 = product of t4 and t5 (temporary)
# $t7 = inner loop counter
# $t8 = sign flag

.data
	n: .word 50
	vector1: .word 10, 20, 35, 50, 15, 8, 40, 25, 30, 70, 60, 10, 80, 25, 55, 45, 90, 20, 60, 75, 40, 85, 95, 15, 5, 30, 65, 70, 55, 85, 50, 35, 7, 20, 99, 42, 1, 62, 7, 18, 22, 9, 5, 32, 58, 48, 77, 68, 11, 29
	vector2: .word -5, -8, -25, -45, -12, -60, -15, -33, -80, -5, -20, -1, -55, -30, -75, -52, -18, -9, -65, -44, -30, -82, -50, -4, -90, -10, -32, -72, -40, -88, -60, -15, -70, -28, -5, -99, -58, -38, -6, -16, -8, -2, -49, -71, -13, -88, -38, -9, -21, -3
	print_message: .asciiz "The answer is: "
    	newline:    .asciiz "\n"

.text
.globl main

main:
    lw $s0, n       # $s0 = n (50)
    la $s1, vector1 # $s1 = base address of vector1
    la $s2, vector2 # $s2 = base address of vector2
    
    add $t0, $zero, $zero  # i = 0 (loop counter)
    add $s7, $zero, $zero  # dot_product_result = 0

main_loop:
    # Calculate byte offset: i * 4
    sll $t1, $t0, 2

    # Load vector elements
    add $t2, $s1, $t1     # address of vector1[i]
    lw $t4, 0($t2)        # $t4 = vector1[i]
    add $t3, $s2, $t1     # address of vector2[i]
    lw $t5, 0($t3)        # $t5 = vector2[i]

    # Initialize temporary product register to 0
    add $t6, $zero, $zero
    
    # Initialize sign flag to 0
    add $t8, $zero, $zero

    # Check signs and adjust
    bltz $t4, v1_neg    # if vector1[i] < 0
    bltz $t5, v2_neg    # if vector2[i] < 0
    j mult_start

v1_neg:
    sub $t4, $zero, $t4 # t4 = |t4|
    addi $t8, $t8, 1    # increment sign flag
    j v2_check

v2_neg:
    sub $t5, $zero, $t5 # t5 = |t5|
    addi $t8, $t8, 1    # increment sign flag
    j mult_start
    
v2_check:
    bltz $t5, v2_neg

mult_start:
    # Inner loop to simulate multiplication by repeated addition
    add $t7, $zero, $zero # inner loop counter
    
mult_loop:
    beq $t7, $t5, mult_end # if counter == |vector2[i]|, exit loop
    add $t6, $t6, $t4    # product = product + |vector1[i]|
    addi $t7, $t7, 1     # counter++
    j mult_loop

mult_end:
    # Adjust sign of the product
    # If the sign flag is odd (1), one original value was negative.
    andi $t9, $t8, 1       # check if sign flag is odd (bit 0 is 1)
    beq $t9, $zero, add_to_sum # if even (0 or 2), product is positive, add to sum
    sub $t6, $zero, $t6     # negate the product

add_to_sum:
    # Add the product to the total sum
    add $s7, $s7, $t6

    # Increment and loop
    addi $t0, $t0, 1
    blt $t0, $s0, main_loop
	

end_program:
    # Print the message
    li $v0, 4
    la $a0, print_message
    syscall

    # Print the result
    add $a0, $s7, $zero  # Load the value to print into $a0
    li $v0, 1  # Set the syscall code for printing an integer
    syscall 

    # Print a newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Program finished, result is in $s7
    # For testing, you could print the value of $s7 here
    li $v0, 10
    syscall