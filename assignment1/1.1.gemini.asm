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
    n: .word 5 # Assuming 50 elements now
	vector1: .word 1, 2, 3, 4, 5
	vector2: .word 6, 7, 8, 9, 10
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
    # Program finished, result is in $s7
    # For testing, you could print the value of $s7 here
    li $v0, 10
    syscall