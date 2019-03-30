# Lista 1 ex 8
# Author: Leonardo Benitez
# Brief: Faça um laço que seja executado 10 vezes.
# Variables map:
#	$s0 = i
	
	addi	$s0, $zero, 0		# int i=0
	addi	$s1, $zero, 9		# int max=10
if:	blt	$s1, $s0, exit		# if (i>=10) jump to exit;
	addi	$s0, $s0, 1		# i++
	j	if
exit:
