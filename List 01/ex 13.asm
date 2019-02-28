# Lista 1 ex 13
# Brief:  receba o endereço do início de uma string e calcule o seu tamanho, em caracteres
# Variables map:
#	$s0 = endereço inicial (0x00)
#	$s1 = endereço incrementável
#	$s2 = loaded value
# Output: tamanho em 0x04
# Pseudo codigo
#	do {loadValue from s1; s1++} while (loaded != 0)
	
	lw	$s0, 0($gp)
	add	$s1, $s0, $zero
do:	
	lb	$s2, 0($s1)
	addi	$s1, $s1, 1
while:	bne	$s2, $zero, do

	sub	$t0, $s1, $s0	
	addi	$t0, $t0, -1		# corrigi o "incremento cego"
	
	sb	$t0, 4 ($gp)