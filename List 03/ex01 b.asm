	li	$t0, 0
while:	bge	$t1, $t2, end
	not	$t3, $t1
	add	$t0, $t0, $t3
	addi 	$t1, $t1, 1
	j while
end: