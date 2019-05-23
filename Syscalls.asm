
	# Print integer
	li	$v0, 1			# Service print integer
	add	$a0, $zero, <intR>	# Service parameter (integer register)
	syscall

	# Print float
	li	$v0, 2			# Service print float
	mov.s	$f12, <floatR>	# Service parameter
	syscall

	# Print double
	li	$v0, 3			# Service print double
	mov.d	$f12, <doubleR>	# Service parameter
	syscall

	# Print string
	li	$v0, 4			# Service print string
	la	$a0, <label>		# Service parameter (address of string)
	syscall


	# Read integer
	li	$v0, 5			# Service read integer (return in v0)
	syscall

	# Read float
	li	$v0, 6			# Service read float (return in f0)
	syscall

	# Read double
	li	$v0, 7			# Service read double (return in f0)
	syscall

	# Read string
	li	$v0, 8			# Service read string
	la	$a0, <string>		# service parameter (address of input buffer)
	li	$a1, 10			# service parameter (maximum number of characters to read)
	syscall

	# Finish program
	li	$v0, 17			# Service terminate
	li	$a0, 0			# Service parameter (termination result)
	syscall
