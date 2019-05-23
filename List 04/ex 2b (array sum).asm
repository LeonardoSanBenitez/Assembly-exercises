main:
	addi	$a0, $gp, 0
	addi	$a1, $zero, 3
	
	jal	ArraySum
	
	add	$a0, $zero, $v0
	li	$v0, 1
	syscall
	
	li	$v0, 17
	syscall
	
#---------------------------------------------------#
# int ArraySum ( int * v , int size ) 
# size is in words, not in bytes
ArraySum:
	li	$v0, 0
ArraySumWhile:
	ble	$a1, $zero, ArraySumEnd	# while (size>0)
	addi	$a1, $a1, -1		# size--
	lw	$t0, 0 ($a0)		# sum += * v ++;
	addi	$a0, $a0, 4
	add	$v0, $v0, $t0		
	j	ArraySumWhile
ArraySumEnd:
	jr	$ra