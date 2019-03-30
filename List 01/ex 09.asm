# Lista 1 ex 9
# Author: Leonardo Benitez
# Brief
#	leia 3 notas dos endereços 0x00, 0x04 e 0x08 e, sabendo que a média é
#	7, armazene 1 no endereço 0x0C caso ele esteja aprovado ou no endereço 0x10 caso ele esteja
#	reprovado.
# Variables maps
#	s0, s1 e s2 = notas


	lw $s0, 0 ($gp)
	lw $s1, 4 ($gp)
	lw $s2, 8 ($gp)

	add $t0, $s0, $s1
	add $t0, $t0, $s2	# t0=média*3

	addi $t1, $zero, 21	# t1=21
	addi $t2, $zero, 1

	bge $t0, $t1, pass
	sw $t2, 16 ($gp)	##reprovado
	j end
pass:	sw $t2, 12 ($gp)	##aprovado
end: