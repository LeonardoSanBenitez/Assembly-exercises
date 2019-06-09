# --------------------------------------------------- #
# Main
# --------------------------------------------------- #
# Brief: Just for testing poupouses.
.text 0x00400000
	addi $t0, $zero, 8
	addi $t1, $zero, 5
	addi $t2, $zero, 1
	addi $t3, $zero, 3
	addi $t4, $zero, 2
	addi $t5, $zero, 20
	addi $t6, $zero, 7
	addi $t7, $zero, 666

	sw $t0, 0 ($gp)
	sw $t1, 4 ($gp)
	sw $t2, 8 ($gp)
	sw $t3, 12 ($gp)
	sw $t4, 16 ($gp)
	sw $t5, 20 ($gp)
	sw $t6, 24 ($gp)
	sw $t7, 28 ($gp)

	add	$a0, $zero, $gp		# array addr: 0x00
	addi	$a1, $zero, 32		# array size (in bytes)

	jal	bubbleSortCrescent

	# Finish program
	li	$v0, 17			# Service terminate
	li	$a0, 0			# Service parameter (termination result)
	syscall
