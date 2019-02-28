# Lista 1 ex 4
# Brief: Faça um laço que seja executado 10 vezes.
# Variables map:
#	$s0 = i
	
	lw $s0, 0 ($gp)		# load A
	lw $s1, 4 ($gp)		# load B
	mul $s1, $s0, $s1	# B = A*B
	sw $s1, 8($gp)