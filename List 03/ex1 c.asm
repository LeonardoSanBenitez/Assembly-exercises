# Registers map
#	end. base A -> $t0
#	i -> $t1
	addi $t1, $zero, 10
do:	
	addi $t1, $t1, -1	# i--
	addi $t3, $zero, 5
	bgt $t1, $t3, if1 	# if i>5
	# Else body: A[i] = 2*i ;
	add $t3, $t0, $t1	# t3 = address of A[i]
	add $t4, $t1, $t1	# t4 = 2*i
	sw $t4, 0($t3)		# A[t3] = t4
	j end1
if1:
	# if body: A[i] = i*i;
	add $t3, $t0, $t1	# t3 = address of A[i]
	mul $t4, $t1, $t1	# t4 = i*i
	sw $t4, 0($t3)		# A[t3] = t4
end1:
	bgt $t1, $zero, do	## while ( i >= 0), goto do