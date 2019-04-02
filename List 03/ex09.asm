# Author: Leonardo Benitez
# Date: 20/03/2019
# Brief: Identificador de ano bissexto

.data
Sbi:	.asciiz "\nO ano é bissexto\n"
Snbi:	.asciiz "\nO ano NÃO é bissexto\n"

.text
	addi $v0, $zero, 5
	syscall
	
	# Se não for divisível por 4. não é bissexto
	addi $t0, $zero, 4
	div $v0, $t0
	mfhi $t1
	bne $t1, $zero, nbi	
	
	# Se for divisível por 100, não é bissexto
	addi $t0, $zero, 100
	div $v0, $t0
	mfhi $t1
	beq $t1, $zero, nbi	
	
	#é bissexto
	addi $v0, $zero, 4	# print string service
	la $a0, Sbi		# service parameter
	syscall
	
	j end
	
nbi:	#não é bissexto	
	addi $v0, $zero, 4	# print string service
	la $a0, Snbi		# service parameter
	syscall
end:	