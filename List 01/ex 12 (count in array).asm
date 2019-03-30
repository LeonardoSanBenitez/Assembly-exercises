# Exercice 12
# Author: Leonardo Benitez
# Brief: count the number of times that a number apears in an array of integers (4 bytes)
# Variables map
#	s0 = base addr (loaded from 0x00)
#	s1 = max array addr (loaded from 0x04, added to base addr)
#	s3 = value to be finded (loaded from 0x08)
#	t0 = temp read
#	t1 = partial count
# Output: count (stored in 0x0C)

	lw $s0, 0($gp)
	lw $s1, 4($gp)
	lw $s2, 8($gp)
	
	add $s1, $s1, $s0
	
w.beg:	bge $s0, $s1, w.end	# while (s0<s1)
	lw $t0, 0($s0)
	bne $t0, $s3, noteq	# if readed!=looked, dont increment partial
	addi $t1, $t1, 1	# partial ++
noteq:
	addi $s0, $s0, 4	# s0++ (increment pointer)
	j w.beg
w.end: 
	sw $t1, 12($gp)
	