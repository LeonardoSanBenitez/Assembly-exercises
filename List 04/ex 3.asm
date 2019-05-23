# DUVIDAS
# a função getFloat deve retornar ou f0 ou em v0?
# meu printFloat tá errado né?


.include "../SyscallsFunctions.asm"



# struct Matriz {
#   int m (begin in byte 0)
#   int n (begin in byte 4)
#   float dados [m][n] (begin in byte 8)
# };
# Total size: 4+4+m*n*4 bytes


.data 
MA: .space 44	# 3x3 matrix
MB: .space 44	# 3x3 matrix
MC: .space 44	# 3x3 matrix

SmatrixBegin: .asciiz "| "
SmatrixSeparator: .asciiz " "
SmatrixBreak: .asciiz "|\n"

Sseparator: .asciiz ", "
SlineBreak: .asciiz "\n"

############################ FUNCTION MAIN
# Stack organization
  # |===========|
  # | $ra       | 4 ($sp)
  # |-----------|
  # | $a0       | 0 ($sp)
  # |-----------|
.text 0x00400000
	add	$sp, $sp, -8	# create stack (2 bytes)
	sw	$ra, 4 ($sp)	# save ra
	
	
	# Init MA
	li	$t0, 3
	la	$t1, MA
	sw	$t0, 0($t1)    # MA.m = 3
	sw	$t0, 4($t1)    # MA.n = 3
	# Init MB
	la	$t1, MB
	sw	$t0, 0($t1)    # MB.m = 3
	sw	$t0, 4($t1)    # MB.n = 3

 	# Init MC
	la	$t1, MC
	sw	$t0, 0($t1)    # MC.m = 3
	sw	$t0, 4($t1)    # MC.n = 3

  	# Read matrices
	la	$a0, MA
	jal	readMatrix

  	# Print matrices
	la	$a0, MA
	jal	printMatrix
	
	# TODO: return
 	# Finish program
	li	$v0, 17			# Service terminate
	li	$a0, 0			# Service parameter (termination result)
	syscall



# --------------------------------------------------- #
# FUNCTION void readMatrix ( struct Matrix *M )
# --------------------------------------------------- #
# Brief: read an float matrix using syscall
# Function prefix: RM
# Variables map
  # t0 = m (line max)
  # t1 = n (col max)
  # t2 = i (line temp)
  # t3 = j (col temp)
# Pseudo code
  # i=0
  # while (i<m)
  #   j=0
  #   while (j<n)
  #     temp = read float
  #     *(M + n*i*4 + j*4 + 8) = temp
  #     j++
  #   i++
# Stack organization
  # | $a0       | 8 ($sp) (quadro anterior)
  # |===========|
  # | $ra       | 4 ($sp)
  # |-----------|
  # | $a0       | 0 ($sp) (available for the next function)
  # |-----------|
readMatrix:
	add	$sp, $sp, -8	# create stack (2 bytes)
	sw	$ra, 4 ($sp)	# save ra
	
	lw	$t0, 0($a0)
	lw	$t1, 4($a0)
	li	$t2, 0
RMw1:
	bge	$t2, $t0, RMend
	li	$t3, 0
RMw2:
	bge	$t3, $t1, RMw2end
	
	# Read user input
	sw	$a0, 8 ($sp)		# save a0 in the previous stack frame (t0, t1, t2 and t3 are not used in the function)
	jal	getFloat		# Proceadure call
	lw	$a0, 8 ($sp)		# restore a0
		
	# Store in matrix
	sll	$t4, $t3, 2	# t4 = j*4
	sll	$t5, $t2, 2	# t5 = i*4
	mul	$t5, $t5, $t1	# t5 = n*i*4
	add	$t4, $a0, $t4	# t4 = M + j*4
	add	$t4, $t4, $t5	# t4 = M + n*i*4 + j*4
	addi	$t4, $t4, 8	# t4 = M + n*i*4 + j*4 + 8
	swc1	$f0, 0 ($t4)
	
	addi	$t3, $t3, 1
	j	RMw2
RMw2end:
	addi	$t2, $t2, 1
	j	RMw1
RMend:
	lw	$ra, 4 ($sp)	# save ra
	add	$sp, $sp, 8	# destroy stack (2 bytes)
	jr	$ra


# --------------------------------------------------- #
# FUNCTION void printMatrix ( struct Matrix *M )
# --------------------------------------------------- #
# Brief: print an float matrix using syscall
# Function prefix: PM
# Variables map
  # t0 = m (line max)
  # t1 = n (col max)
  # t2 = i (line temp)
  # t3 = j (col temp)
# Pseudo code
  # i=0
  # while (i<m)
  #   print "|"
  #   j=0
  #   while (j<n)
  #     temp = *(M + n*i*4 + j*4 + 8)
  #     printFloat (temp)
  #     j++
  #   print "|\n"
  #   i++
# Stack organization
  # | $a0       | 8 ($sp) (quadro anterior)
  # |===========|
  # | $ra       | 4 ($sp)
  # |-----------|
  # | $a0       | 0 ($sp) (available for the next function)
  # |-----------|
printMatrix:
	add	$sp, $sp, -8	# create stack (2 bytes)
	sw	$ra, 4 ($sp)	# save ra
	
	lw	$t0, 0($a0)
	lw	$t1, 4($a0)
	li	$t2, 0
PMw1:
	bge	$t2, $t0, PMend
	
	sw	$a0, 8 ($sp)		# save a0 in the previous stack frame (t0, t1, t2 and t3 are not used in the function)
	la	$a0, SmatrixBegin	# Proceadure parameter
	jal	printString		# Proceadure call
	lw	$a0, 8 ($sp)		# restore a0
	
	li	$t3, 0
PMw2:
	bge	$t3, $t1, PMw2end
	
	# load float
	sll	$t4, $t3, 2	# t4 = j*4
	sll	$t5, $t2, 2	# t5 = i*4
	mul	$t5, $t5, $t1	# t5 = n*i*4
	add	$t4, $a0, $t4	# t4 = M + j*4
	add	$t4, $t4, $t5	# t4 = M + n*i*4 + j*4
	addi	$t4, $t4, 8	# t4 = M + n*i*4 + j*4 + 8
	
	# Print float
	sw	$a0, 8 ($sp)		# save a0 in the previous stack frame (t0, t1, t2 and t3 are not used in the function)
	move	$a0, $t4		# Proceadure parameter
	jal	printFloat
	lw	$a0, 8 ($sp)		# restore a0	
		
	# Print separator
	sw	$a0, 0 ($sp)		# save a0
	la	$a0, SmatrixSeparator	# Proceadure parameter
	jal	printString		# Proceadure call
	lw	$a0, 0 ($sp)		# restore a0
		
	addi	$t3, $t3, 1
	j	PMw2
PMw2end:
	sw	$a0, 0 ($sp)		# save a0
	la	$a0, SmatrixBreak	# Proceadure parameter
	jal	printString		# Proceadure call
	lw	$a0, 0 ($sp)		# restore a0
	
	addi	$t2, $t2, 1
	j	PMw1
PMend:
	lw	$ra, 4 ($sp)	# save ra
	add	$sp, $sp, 8	# destroy stack (2 bytes)
	jr	$ra
	
	
	

# --------------------------------------------------- #
# FUNCTION void opositeMatrix ( struct Matrix *M )
# --------------------------------------------------- #
# Brief: calculates the oposite of the matrix (Moposite=-M)
# Function prefix: OM
# Variables map
  # t0 = m (line max)
  # t1 = n (col max)
  # t2 = i (line temp)
  # t3 = j (col temp)
# Pseudo code
  # i=0
  # while (i<m)
  #   j=0
  #   while (j<n)
  #     temp = *(M + n*i*4 + j*4 + 8)
  #	temp = -temp
  #     *(M + n*i*4 + j*4 + 8) = temp
  #     j++
  #   i++
# Stack organization
  # | $a0       | 8 ($sp) (quadro anterior)
  # |===========|
  # | $ra       | 4 ($sp)
  # |-----------|
  # | $a0       | 0 ($sp) (available for the next function)
  # |-----------|
opositeMatrix:
	add	$sp, $sp, -8	# create stack (2 bytes)
	sw	$ra, 4 ($sp)	# save ra
	
	lw	$t0, 0($a0)
	lw	$t1, 4($a0)
	li	$t2, 0
OMw1:
	bge	$t2, $t0, OMend
	li	$t3, 0
OMw2:
	bge	$t3, $t1, OMw2end
	

	# Read from in matrix
	sll	$t4, $t3, 2	# t4 = j*4
	sll	$t5, $t2, 2	# t5 = i*4
	mul	$t5, $t5, $t1	# t5 = n*i*4
	add	$t4, $a0, $t4	# t4 = M + j*4
	add	$t4, $t4, $t5	# t4 = M + n*i*4 + j*4
	addi	$t4, $t4, 8	# t4 = M + n*i*4 + j*4 + 8
	swc1	$f0, 0 ($t4)
	
	addi	$t3, $t3, 1
	j	OMw2
OMw2end:
	addi	$t2, $t2, 1
	j	OMw1
OMend:
	lw	$ra, 4 ($sp)	# save ra
	add	$sp, $sp, 8	# destroy stack (2 bytes)
	jr	$ra
	