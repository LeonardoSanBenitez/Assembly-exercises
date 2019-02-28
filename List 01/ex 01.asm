# Lista 1 ex 1
# Variables map:
# 	$t0=Base
# 	$t1=A
#	$t2 = B
# Pseudocode:
#	Load from memory to A and B
#	B = A + B
#	Store B in memory

addi	$t0, $zero, 0x10008000	# base addr
#lw	$t1, 0 ($t0)
#lw	$t2, 4 ($t0)
addi	$t1, $zero, 10
addi	$t2, $zero, 20
add	$t2, $t1, $t2		# B = A + B
sw	$t2, 8 ($t0)		# store B