## NÃO FUNCIONA, PEGUEI DO SLIDE DA UFSC

addi $a0, $zero, 1
# int factorial (int n)
factorial:
	addi	$sp, $sp, -8	# stack malloc 2 words
	sw	$a0, 0($sp) 	# stack push
	sw	$ra, 4($sp)	# stack push
	
	slti	$t0, $a0, 1	
	beq	$t0, $zero, L1	# if (a0>1) goto L1
	
	# return 1
	addi	$v0, $zero, 1
	addi	$sp, $sp, 8	# free stack 2 word
	jr	$ra		# return (1)
	
	#return n*factorial(n-1)
L1:	addi	$a0, $a0, -1
	jal	factorial	# factorial (n-1)
	
	lw	$a0, 0($sp)	# stack pop
	lw	$ra, 4($sp)	# stack pop
	addi	$sp, $sp, 8	# free stack 2 word
	
	mul	$v0, $a0, $v0
	jr	$ra		# return n*factoria (n-1)
	