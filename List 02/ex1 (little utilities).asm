# Register map
# 	f → $s0
# 	g → $s1
# 	h → $s2
# 	i → $s3
# 	j → $s4)
# 	base(A) → $s6
# 	Base(B) → $s7


# f = g ∗ h + i
mul $s0, $s1, $2
add $s0, $s0, $s3

# f = g ∗ (h + i)
add $s0, $s2 $s3
mul $s0, $s0, $s1

# f = g + (h − 5)
add $s0, $s1, $s2
addi $s0, $s0, -5

# [f, g] = (h ∗ i) + (i ∗ i) # resultado de 64 bits, Hi em f e Lo em g
mult $s2, $s3
mfhi $t0
mflo $t1
mult $s3, $s3
mfhi $t2
mflo $t3
add $s0, $t0, $t2
add $s1, $t1, $t3

# f = g ∗ 9 (sem utilizar a instrução de multiplicação)
	add $t0, $zero, $zero	#i=0
	addi $t1, $zero 9
loop:	bge $t0, $t1, end	# for (i=0; i<9; i++)
	add $s0, $s0, $s1
	addi $t0, $t0, 1
	j loop
end:

# f = 2^h (if g>0)
	addi $s2, $zero, 2
	add $t0, $zero, $zero	#i=0
	addi $s3, $zero 9
loop:	bge $t0, $s3, end	# for (i=0; i<9; i++)
	add $s0, $s0, $s1
	addi $t0, $t0, 1
	j loop
end:

# h = min(f, g)
	bgt $s0, $s1 # if f>g, go to then
	add $s3, $zero, $s0
	j end
then: 	add $s3, $zero, $s1
end:

# h = max(f, g)
	bgt $s0, $s1 # if f>g, go to then
	add $s3, $zero, $s1
	j end
then: 	add $s3, $zero, $s0
end:
# B[8] = A[i − j]
# s0 = B addr
# s1 = A addr
# s2 = i
# s3 = j

add 	$t0, $s1, $s2
sub		$t0, $t0, $s3		#  = $t0 - $s3
lw 		$t1, 0($t0)
sw 		$t1, 32($s0)


# B[32] = A[i] + A[j]
# i → $s3
# j → $s4
# A addr → $s6
# B addr → $s7
add		$t0, $s6, $s3		# $t0 = $s6 + $s3
add		$t1, $s6, $s4		# $t1 = $s6 + $s4
lw		$t0, 0($t0)			# A[i]
lw		$t1, 0($t1)			# A[j]
add		$t0, $t0, $t1		# $t0 = $t0 + $t1
sw		$t0, 128($s7)
