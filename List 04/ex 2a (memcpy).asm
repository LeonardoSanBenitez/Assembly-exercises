main:
	addi	$a0, $gp, 0
	addi	$a1, $gp, 16
	addi	$a2, $zero, 12
	
	jal	memcpy
	
	li	$v0, 17
	syscall
	
#---------------------------------------------------#
# void memcpy ( char * src , char * dst , int bytes )
memcpy:
	ble	$a2, $zero, memcpyEnd	# while (bytes>0)
	addi	$a2, $a2, -1		# bytes--
	lb	$t0, 0($a0)		# * dst ++ = * src ++;
	addi	$a0, $a0, 1
	sb	$t0, 0 ($a1)
	addi	$a1, $a1, 1
	j	memcpy
memcpyEnd:
	jr	$ra