# Author: Leonardo Benitez
# Date: 20/03/2019
# Brief: Recebeum array de inteiros, devolve o somatório e a média (armazenando e processando separadamente)
# Variables map
#	s0 = array size
#	s1 = sum
#	s2 = mean


# DESCCRIÇÃO DA DUVIDA
# quando descomento a 
.data
Dhead:	.asciiz "Por favor, insira o tamanho do array (max 2048 elementos)\n"
##Dask:	.asciiz "\nInsira o valor do elemento: "
Derror:	.asciiz "Tamanho inválido, tente novamente\n"
Dsum:	.asciiz "Sum: "
Dmean:	.asciiz "\nMean: "
.align 2
Darray:	 .space 8192
.text
ask:	addi $v0, $zero, 4	# print string service ($a0=addres)
	la $a0, Dhead		# service parameter
	syscall
	
	addi $v0, $zero, 5	# read integer service (result in $v0)
	syscall
	add $s0, $zero, $v0
	
	# Boundary check: if (size > 2048 and size<0) jump to error
	addi $t0, $zero, 2048
	bgt $s0, $t0, error
	blt $s0, $zero, error
	
	# array insertion
	la $t0, Darray		# t0 = array pointer
	sll $t2, $s0, 2		# convert size to bytes
	add $t1, $t0, $t2	# t1 = max array addr
loop1:	bge $t0, $t1, output#calc	# while (ptr < ptrMax)


	addi $v0, $zero, 5	# read integer service (result in $v0)
	syscall
	sw $v0, 0($t0)		# put received value in memory
	addi $t0, $t0, 4	# ptr++
	j loop1
	
	# calculations
calc:	la $t0, Darray		# t0 = array pointer
	sll $t2, $s0, 2		# convert size to bytes
	add $t1, $t0, $t2	# t1 = max array addr
loop2:	bge $t0, $t1, calc	# while (ptr < ptrMax)
	lw $t3, 0 ($t0)
	add $s1, $s1, $t3
	addi $t0, $t0, 4	# ptr++
	j loop2

	# error messague
error:	addi $v0, $zero, 4	# print string service ($a0=addres)
	la $a0, Derror		# service parameter
	syscall	
	j ask

	#Show calculations
output:	#mean = sum/$s0
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
	
