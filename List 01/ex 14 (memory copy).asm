# Lista 1 ex 14
# Author: Leonardo Benitez
# Brief:  receba dois endereços de memória e faça a transferência dos dados
# Variables map:
#	$s0 = endereço da fonte (0x00)
#	$s1 = endereço do destino (0x04)
#	$s2 = tamanho a ser copiado (0x08)
#	$s3 = contador temporário
# Pseudo codigo
#	while (i < max){load value; store value; i++}
	
	lw	$s0, 0($gp)
	lw	$s1, 4($gp)
	lw	$s2, 8($gp)
	add	$s3, $zero, $zero
	
while:	bge 	$s3, $s2, exit		# if (i >= max)	goto exit
	lb	$t0, 0 ($s0)
	sb	$t0, 0 ($s1)
	addi	$s0, $s0, 1		# soure ++
	addi	$s1, $s1, 1		# dest ++
	addi	$s3, $s3, 1		# i++
	j while
exit:
