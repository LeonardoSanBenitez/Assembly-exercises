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
# f = g ∗ 9 (do not use mult)
# f = 2^g (if g>0)
# h = min(f, g)
# h = max(f, g)
# B[8] = A[i − j]
# B[32] = A[i] + A[j]

