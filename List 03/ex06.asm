# Registers map
#	s0 = a
#	s1 = b
#	s2 = Base addr of D
#	t0 = i
#	t1 = j
# Pseudo code
# 	for ( i =0; i < a ; i ++)
# 	for ( j =0; j < b ; j ++)
# 	D [4*j] = i + j;

	add $t0, $zero, $zero
	add $t1, $zero, $zero
for1b: 	bge $t0, $s0, for1e	# if i>=a, goto end of for1
for2b: 	bge $t1, $s1, for2e	# if i>=a, goto end of for2
	
	add $t2, $t0, $t1	#t2 = i+j
	sll $t3, $t1, 2		#t3 = 4j
	add $t3, $t3, $s2
	sw $t2, 0($t3)
	
	addi $t0, $t0, 1	#j++
	j for1b
for2e:	
	addi $t0, $t0, 1	#i++
	j for1b
for1e:

