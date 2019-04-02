# Encontre a sequência mais curta da instrução MIPS que extraia os bits [16:11] do registrador $t0
# e use esse valor para substituir os bits [31:26] no registrador $t1 sem alterar os outros 26 bits do
# registrador $t1.

andi	$t2, $t0, 0x0000FC00	# 00000000 00000000 11111100 00000000
sll	$t2, $t2, 16
andi	$t1, $t1, 0x00FFFFFF
or	$t1, $t1, $t2