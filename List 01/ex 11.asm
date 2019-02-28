# Lista 1 ex 11
# Brief: buscar um determinado valor em um array de inteiros (NÃO FUNCIONA)
# Variables map:
#	$s0 = endereço inicial (0x00)
#	$s1 = tamanho do vetor (0x04)
#	$s2 = valor a ser pesquisado (0x08)
#	$t0 = variável de iteração
#	$t1 = valor verificado
# Output: encontrou (1) ou não (0) em 0x0C
# Pseudo codigo
#	carrega valores
#	do {load from i; i+=4} while (t1 != s2 and i<=s1)
#	if (t1=s2), print "true"
	
	add	$t0, $zero, $zero 	# init i
	lw	$s0, 0($gp)
	lw	$s1, 4($gp)
	lw	$s2, 8($gp)
	mul	$s1, $s1, 4		# transforma tamanho para bytes 
	
do:	lw	$t1, $t0 ($s0)
	addi	$t0, $t0, 4
	beq	$t1, $s2, true		# set if t1 == s2
	bleu 	$t0, $s1, do
	
	sw	$zero, 12($gp)		# set false
	j end
true:	addi	$t2, $zero, 1
	sw 	$t2, 12 ($gp)		# set true
end: 				
		
	
	
