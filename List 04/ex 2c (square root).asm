	li	$a0, 25			# Debug value
	jal	sqrti
	
	add	$a0, $v0, $zero		# Service parameter (integer register)	
	li	$v0, 1			# Service print integer
	syscall
	
	li	$v0, 17			# Service terminate
	li	$a0, 0			# Service parameter (termination result)
	syscall
# -----------------------------------------------------
# FUNCTION SQRTi
# Brief: Calculates the square root of an integer
# Algorithm
  # int sqrti ( int num ) {
  #   int res = 0;
  #   int bit = 1 << 30;
  #   while ( bit > num )
  #     bit > >= 2;
  #   while ( bit != 0) {
  #     if ( num >= res + bit ) {
  #       num -= res + bit ;
  #       res = ( res >> 1) + bit ;
  #     }
  #     else{
  #       res > >= 1;
  #     }
  #     bit > >= 2;
  #   }
  #   return res ;
  # }
# Variables map
  #	t0 = res
  #	t1 = bit
  #	a0 = num
  
sqrti:
	li	$t0, 0
	li	$t1, 1
	sll	$t1, $t1, 30
sqrtW1:	ble	$t1, $a0, sqrtW2	# while (bit > num)
	srl	$t1, $t1, 2		# bit >>= 2;
	j	sqrtW1
sqrtW2:	beq	$t1, $zero, sqrtEnd
	add	$t2, $t0, $t1		# t2 = res + bit
	bge	$a0, $t2, sqrtThen
	srl	$t0, $t0, 1
	j	sqrtIfEnd
sqrtThen:
	sub	$a0, $a0, $t2		# num = num - (res + bit)
	srl	$t2, $t0, 1		# t2 = ( res >> 1) 
	add	$t0, $t2, $t1		# res = t2 + bit
sqrtIfEnd:
	srl	$t1, $t1, 2
	j	sqrtW2
sqrtEnd:
	add	$v0, $t0, $zero
	jr	$ra
	# return res
	
	
	
	
	
	
	
	
	