# Author: Leonardo Benitez
# Date: 20/03/2019
# Brief: Recebeum array de inteiros, devolve o somatório e a média
# Variables map
#	s0 = array size
#	s1 = sum
#	s2 = mean
.data
Dhead:	.asciiz "Por favor, insira o tamanho do array (max 2048 elementos)\n"
Derror:	.asciiz "Tamanho inválido, tente novamente\n"
Dsum:	.asciiz "Sum: "
Dmean:	.asciiz "\nMean: "

Darray:	.space 8192

.text
ask:	addi $v0, $zero, 4	# print string service ($a0=addres)
	la $a0, Dhead		# service parameter
	syscall
	
	addi $v0, $zero, 5	# read integer service (result in $v0)
	syscall
	add $s0, $zero, $v0
	
	# Boundary check
	addi $t0, $zero, 2048
	sle $t1, $s0, $t0	# t1=okFlag. if (size <= 2048    USE DOIS REGISTRADORES
	sle $t1, $zero, $s0	# and size>=0)
	bne $t1, $zero, ok	# jump to ok
	addi $v0, $zero, 4	# print string service ($a0=addres)
	la $a0, Derror		# service parameter
	syscall	
	j ask
ok:
	# calcuations
	
	#Output
	addi $v0, $zero, 4	# print string service ($a0=addres)
	la $a0, Dsum		# service parameter
	syscall	
	
	addi $v0, $zero, 1	# print integer service ($a0=value)
	add $a0, $zero, $s1	# service parameter
	syscall
	
	addi $v0, $zero, 4	# print string service ($a0=addres)
	la $a0, Dmean		# service parameter
	syscall	
	
	addi $v0, $zero, 1	# print integer service ($a0=value)
	add $a0, $zero, $s2	# service parameter
	syscall
	