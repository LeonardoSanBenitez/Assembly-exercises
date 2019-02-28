# Lista 1 ex 4

	lw	$t0, 0 ($gp)
	blt	$t0, $zero, neg
	sw	$t0, 4 ($gp)		# If (t0>=0) store in 0x04
	j	exit
neg:	sw	$t0, 8 ($gp)		# if (t0<0) store in 0x08
exit: 
