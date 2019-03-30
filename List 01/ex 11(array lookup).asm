# Lista 1 ex 11
# Brief: buscar um determinado valor em um array de inteiros
# Variables map:
#	$s0 = array pointer
#	$s1 = array end addr
#	$s2 = valor a ser pesquisado (0x08)
# Output: encontrou (1) ou não (0) em 0x0C
# Pseudo codigo
.data
Syes:	.asciiz "O valor foi encontrado :) \n"
Sno:	.asciiz "O valor não foi encontrado :( \n"
.text
	## debug begin
	addi $t0, $zero, 0x1000800C
	addi $t1, $zero, 1
	addi $t2, $zero, 2
	addi $t3, $zero, 3
	addi $t4, $zero, 4
	addi $t5, $zero, 5
	
	
	sw $t0, 0($gp)
	sw $t4, 4($gp)
	#sw $t2, 8($gp)	# encontrará
	sw $t5, 8($gp)	# não encontrará
	
	sw $t1, 12($gp)
	sw $t2, 16($gp)
	sw $t3, 20($gp)
	sw $t4, 24($gp)
	sw $t5, 28($gp)
	##debug end
	
	lw	$s0, 0($gp)	# endereço inicial (0x00)
	lw	$s1, 4($gp)	# tamanho do vetor (0x04)
	lw	$s2, 8($gp)	# valor a ser pesquisado (0x08)
	
	mul	$s1, $s1, 4	# transforma tamanho para bytes
	add	$s1, $s1, $s0
	
while:	bge	$s0, $s1, no	# while (s0 < s1)
	lw	$t0, 0($s0)
	beq	$t0, $s2, yes	# if readed==desired, goto yes
	addi	$s0, $s0, 4	# ptr++
	j while
yes:
	li	$v0, 4		# Print string service
	la	$a0, Syes	# service parameter
	syscall	
	j end
no:
	li	$v0, 4		# Print string service
	la	$a0, Sno	# service parameter
	syscall	
end: