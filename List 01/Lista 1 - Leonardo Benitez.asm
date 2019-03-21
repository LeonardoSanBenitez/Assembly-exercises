# List 1 ex 1
# Variables map:
# 	$t0=Base
# 	$t1=A
#	$t2 = B
# Pseudocode:
#	Load from memory to A and B
#	B = A + B
#	Store B in memory

lw $t0, 0($gp) 
lw $t1, 4($gp)
add $t2, $t1, $t0	# B = A + B
sw $t2, 8($gp)		# store B

#----------------------------------------------------------------------------#
# List 1 ex 2

	lw $t0, 0($gp)
	lw $t1, 4($gp)
	add $t2, $t1, $t0
	lw $t0, 8($gp)
	add $t2, $t2, $t0
	sw $t2, 12($gp)

#----------------------------------------------------------------------------#
# List 1 ex 3

	lw $t0, 0($gp)
	lw $t1, 4($gp)
	sub $t2, $t1, $t0  #t1-#t0
	sw $t2, 8($gp)

#----------------------------------------------------------------------------#
# List 1 ex 4

		lw	$t0, 0 ($gp)
		blt	$t0, $zero, neg
		sw	$t0, 4 ($gp)		# If (t0>=0) store in 0x04
		j	exit
neg:	sw	$t0, 8 ($gp)		# if (t0<0) store in 0x08
exit:

#----------------------------------------------------------------------------#
# List 1 ex 5

main:
		lw $t0, 0($gp)
		lw $t1, 4($gp)
		beq $t0, $t1, eq
		j end
eq:		sw $t0, 8($gp)
end:

#----------------------------------------------------------------------------#
# List 1 ex 6

		lw $t0, 0($gp)
		lw $t1, 4($gp)
		sub $t2, $t0, $t1
		bgez $t2, big
		sw $t1, 8($gp)
		j end
big: 	sw $t0, 8($gp)
end:


#----------------------------------------------------------------------------#
# List 1 ex 7
# Brief: ordenação crescente de 3 vetores

		add $s0, $zero, $gp
		li $t4, 2
loop1:	beqz $t4, end
		li $t5, 2
loop2:	beqz $t5 , endif1
		lw $t0, 0($s0)
		lw $t1, 4($s0)
		ble $t0 , $t1, endif2
		sw $t0, 4($s0)
		sw $t1, 0($s0)
endif2:	sub $t5, $t5, 1
		add $s0, $gp, 4
		j loop2
endif1: sub $t4, $t4, 1
		add $s0, $zero, $gp
		j loop1
end:

#----------------------------------------------------------------------------#
# Lista 1 ex 8
# Brief: Faça um laço que seja executado 10 vezes.
# Variables map:
#	$s0 = i

	addi	$s0, $zero, 0		# int i=0
	addi	$s1, $zero, 9		# int max=10
if:	blt	$s1, $s0, exit			# if (i>=10) jump to exit;
	addi	$s0, $s0, 1			# i++
	j	if
exit:

#----------------------------------------------------------------------------#
# Lista 1 ex 9
# brief: lê 3 notas e devolve se o aluno passou (média>7)
lw $s0, 0 ($gp)
lw $s1, 4 ($gp)
lw $s2, 8 ($gp)

add $t0, $s0, $s1
add $t0, $t0, $s2 # t0=média*3

addi $t1, $zero, 21 # t1=21
addi $t2, $zero, 1

bge $t0, $t1, pass
sw $t2, 16 ($gp)	##reprovado
j end
pass:	sw $t2, 12 ($gp)	##aprovado
end:


#----------------------------------------------------------------------------#
# Lista 1 ex 10
# Brief: Faça um laço que seja executado 10 vezes.
# Variables map:
#	$s0 = i

	lw $s0, 0 ($gp)		# load A
	lw $s1, 4 ($gp)		# load B
	mul $s1, $s0, $s1	# B = A*B
	sw $s1, 8($gp)

#----------------------------------------------------------------------------#
# Lista 1 ex 11
# Brief: buscar um determinado valor em um array de inteiros
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

#----------------------------------------------------------------------------#
# Lista 1 ex 12
# Brief: contar o número de elementos encontrados em um array de inteiros
# Variables map:
#	$s0 = endereço inicial (0x00)
#	$s1 = tamanho do vetor (0x04)
#	$t0 = variável de iteração
#	$t1 = valor verificado
# Output: gravar em 0x0C o numero de elementos encontrados

	add	$t0, $zero, $zero 	# init i
	lw	$s0, 0($gp)
	lw	$s1, 4($gp)
	lw	$s2, 8($gp)
	mul	$s1, $s1, 4			# transforma tamanho para bytes

do:	lw	$t1, 0 ($s0)		# conta numero de elementos
	addi	$t0, $t0, 4
	addi	$s0, $s0, 4
	bleu 	$t0, $s1, do

	sw 	$t0, 12 ($gp)		# gravar resultado

#----------------------------------------------------------------------------#
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

#----------------------------------------------------------------------------#
# Lista 1 ex 14
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
