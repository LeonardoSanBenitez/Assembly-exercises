# --------------------------------------- #
#  Libraries
# --------------------------------------- #
.text 0x00500000
.include "../Libraries/SyscallsFunctions.asm"
.include "../Libraries/macros.asm"

# --------------------------------------------------- #
# Main
# --------------------------------------------------- #
# Stack organization
  # |===========|
  # | $a0       | 0 ($sp)
  # |-----------|
.text 0x00400000
	add	$sp, $sp, -4	# create stack (1 byte)

	# test perfectSquare
	li	$s1, 1		# temp number
	li	$s0, 10		# max
loop:	bgt	$s1, $s0, loopEnd
	move	$a0, $s1
	jal	perfectSquare
	move	$a0, $v0
	jal	printInt
	print_str (" ")
	addi	$s1, $s1, 1
	j	loop
loopEnd:
	 # Finish program
	li	$v0, 17			# Service terminate
	li	$a0, 0			# Service parameter (termination result)
	syscall


# --------------------------------------------------- #
# FUNCTION int perfectSquare (int n)
# --------------------------------------------------- #
# Brief: calcula n**2, porém de um jeito recursivo
# Function prefix: PS
# Variables map
  # ??
# Pseudo code
  # if (n==0)
  #   return 0
  # else
  #   return perfectSquare(n-1) + 2n - 1
# Stack organization
  # | $a0       | 8 ($sp) (quadro anterior)
  # |===========|
  # | $ra       | 4 ($sp)
  # |-----------|
  # | $a0       | 0 ($sp) (available for the next function)
  # |-----------|
perfectSquare:
	add	$sp, $sp, -8	# create stack (2 bytes)
	sw	$ra, 4($sp)	# save ra

	bne	$a0, $zero, PSelse # if (n==0) return n
	add	$v0, $zero, $zero
	add	$sp, $sp, 8	# destroy stack (2 bytes)
	jr	$ra		# dont need to restore ra, cause it was not maculated
PSelse:
  	sw	$a0, 8($sp)	# salva a0 na stack anterior
  	addi	$a0, $a0, -1	# parameter to the new function
  	jal	perfectSquare
  	lw	$a0, 8($sp)	# restaura a0

  	sll	$a0, $a0, 1	# a0 *= 2
  	add	$v0, $v0, $a0	# v0 = perfectSquare(n-1) + 2n
  	addi	$v0, $v0, -1	# v0 = perfectSquare(n-1) + 2n -1

  	lw	$ra, 4($sp)	# restore ra
  	add	$sp, $sp, 8	# destroy stack (2 bytes)
  	jr	$ra
