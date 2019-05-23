.data
Sseparator: .asciiz ", "
SlineBreak: .asciiz "\n"

.text
main:
	## debug init
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
	## debug end
	
	addi	$a0, $gp, 0
	addi	$a1, $zero, 7
	
	jal	printArray
	
	li	$v0, 17
	syscall
	
#------------------------------#
# void printArray (int* v, int size)
printArray:
	move	$t1, $a0
printArrayWhile:
	ble	$a1, $zero, printArrayEnd	# while (size>0)
	addi	$a1, $a1, -1		# size--

	lw	$a0, 0 ($t1)		# print_int (* v ++) 
	addi	$t1, $t1, 4
	li	$v0, 1
	syscall	
	
	la	$a0, Sseparator
	li	$v0, 4
	syscall
	
	j	printArrayWhile
printArrayEnd:
	la	$a0, SlineBreak
	li	$v0, 4
	syscall
	
	jr	$ra