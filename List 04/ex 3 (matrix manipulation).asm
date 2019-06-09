# --------------------------------------- #
#  Libraries
# --------------------------------------- #
.text 0x00500000
.include "../Libraries/SyscallsFunctions.asm"
.include "../Libraries/macros.asm"


# --------------------------------------- #
#  Global Variables
# --------------------------------------- #
# struct Matriz {
#   int m (begin in byte 0)
#   int n (begin in byte 4)
#   float dados [m][n] (begin in byte 8)
# };
# Total size: 4+4+m*n*4 bytes
.data
#MA: .space 44	# 3x3 matrix
#MA: .float 0, 0, 3,2,1,6,5,4,9,8,7 #DEBUG
MA: .float 0, 0, 1,2,3,4 #DEBUG
#MB: .space 44	# 3x3 matrix
MB: .float 0, 0, 2,2,2,2,2,2,2,2,2 #DEBUG
MC: .space 44	# 3x3 matrix

SmatrixBegin: .asciiz "| "
SmatrixSeparator: .asciiz " "
SmatrixBreak: .asciiz "|\n"

Sseparator: .asciiz ", "
SlineBreak: .asciiz "\n"

negative: .float -1

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
	li	$t0, 2
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
	#la	$a0, MA
	#jal	readMatrix

  	# Print matrices
	#la	$a0, MA
	#jal	printMatrix
	#la	$a0, MB
	#jal	printMatrix

	#invert
	#la	$a0, MA
	#jal	opositeMatrix
	#la	$a0, MA
	#jal	printMatrix

	# Sum
	#la	$a0, MC
	#la	$a1, MA
	#la	$a2, MB
	#jal	sumMatrix
	#la	$a0, MC
	#jal	printMatrix

	# Transpose
	#la	$a0, MA
	#jal	printMatrix
	#la	$a0, MA
	#la	$a1, MB
	#jal	transposeMatrix
	#la	$a0, MB
	#jal	printMatrix

	# Determinant
	la	$a0, MA
	jal	printMatrix
	la	$a0, MA
	jal	detMatrix2
	add	$a0, $v0, $zero
	jal	printFloat

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
	lw	$a0, 0 ($t4)		# Proceadure parameter
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


	# Read from matrix
	sll	$t4, $t3, 2	# t4 = j*4
	sll	$t5, $t2, 2	# t5 = i*4
	mul	$t5, $t5, $t1	# t5 = n*i*4
	add	$t4, $a0, $t4	# t4 = M + j*4
	add	$t4, $t4, $t5	# t4 = M + n*i*4 + j*4
	addi	$t4, $t4, 8	# t4 = M + n*i*4 + j*4 + 8
	lwc1	$f0, 0 ($t4)

	# invert and store
	lwc1	$f2, negative	#f2=-1
	mul.s	$f0, $f0, $f2
	swc1	$f0, 0($t4)

	addi	$t3, $t3, 1
	j	OMw2
OMw2end:
	addi	$t2, $t2, 1
	j	OMw1
OMend:
	lw	$ra, 4 ($sp)	# save ra
	add	$sp, $sp, 8	# destroy stack (2 bytes)
	jr	$ra



# --------------------------------------------------- #
# FUNCTION void sumMatrix ( struct Matriz * dst , struct Matriz * a , struct Matriz * b )
# --------------------------------------------------- #
# Brief: sum two matrix (Cij = Aij + Bij), if that operation is possible (equal order)
# Function prefix: SM
# Variables map
  # t0 = m (line max)
  # t1 = n (col max)
  # t2 = i (line temp)
  # t3 = j (col temp)
# Pseudo code
  # if (ma!=mb or ma!=mc or na!=nb or na!=nc) print error; return;
  # i=0
  # while (i<m)
  #   j=0
  #   while (j<n)
  #	pos = n*i*4 + j*4 + 8
  #     a = *(Ma + pos)
  #	b = *(Mb + pos)
  #	*(Mc + pos) = a+b
  #     j++
  #   i++
# Stack organization
  # | $a0       | 8 ($sp) (quadro anterior)
  # |===========|
  # | $ra       | 4 ($sp)
  # |-----------|
  # | $a0       | 0 ($sp) (available for the next function)
  # |-----------|
sumMatrix:
	add	$sp, $sp, -8	# create stack (2 bytes)
	sw	$ra, 4 ($sp)	# save ra

	# check if operation is possible
	lw	$t0, 0($a0)	# am
	lw	$t1, 4($a0)	# an
	lw	$t2, 0($a1)	# bm
	lw	$t3, 4($a1)	# bn
	lw	$t4, 0($a2)	# cm
	lw	$t5, 4($a2)	# cn
	bne	$t0, $t2, SMerror
	bne	$t0, $t4, SMerror
	bne	$t1, $t3, SMerror
	bne	$t1, $t5, SMerror

	li	$t2, 0
SMw1:
	bge	$t2, $t0, SMend
	li	$t3, 0
SMw2:
	bge	$t3, $t1, SMw2end


	# Read from matrix
	sll	$t4, $t3, 2	# t4 = j*4
	sll	$t5, $t2, 2	# t5 = i*4
	mul	$t5, $t5, $t1	# t5 = n*i*4
	add	$t4, $t4, $t5	# t4 = n*i*4 + j*4
	addi	$t4, $t4, 8	# t4 = n*i*4 + j*4 + 8

	add	$t6, $a1, $t4	# t6 = Ma + pos
	lwc1	$f0, 0 ($t6)

	add	$t6, $a2, $t4	# t6 = Mb + pos
	lwc1	$f2, 0 ($t6)

	# sum and store
	add.s	$f0, $f0, $f2	# f0 = aij + bij
	add	$t6, $a0, $t4	# t6 = Mc + pos
	swc1	$f0, 0($t6)

	addi	$t3, $t3, 1
	j	SMw2
SMw2end:
	addi	$t2, $t2, 1
	j	SMw1

SMerror:
	print_str ("sumMatrix: operation impossible\n")
SMend:
	lw	$ra, 4 ($sp)	# save ra
	add	$sp, $sp, 8	# destroy stack (2 bytes)
	jr	$ra




# --------------------------------------------------- #
# FUNCTION void transposeMatrix ( struct Matriz * dest, struct Matriz * src )
# --------------------------------------------------- #
# Brief: transpose the matrix (aij = aji). Dest matrix should have the right dimention
# Function prefix: TM
# Variables map
  # t0 = m (line max)
  # t1 = n (col max)
  # t2 = i (line temp)
  # t3 = j (col temp)
# Pseudo code
  # if (Bj!=Ai or Bi!=Aj) print error; return;
  # i=0
  # while (i<m)
  #   j=0
  #   while (j<n)
  #     transpose[j][i] = matrix[i][j];
  #     j++
  #   i++
# Stack organization
  # | $a0       | 8 ($sp) (quadro anterior)
  # |===========|
  # | $ra       | 4 ($sp)
  # |-----------|
  # | $a0       | 0 ($sp) (available for the next function)
  # |-----------|
transposeMatrix:
	add	$sp, $sp, -8	# create stack (2 bytes)
	sw	$ra, 4 ($sp)	# save ra

	# check if operation is possible
	lw	$t0, 0($a0)	# am
	lw	$t1, 4($a0)	# an
	lw	$t2, 0($a1)	# bm
	lw	$t3, 4($a1)	# bn
	bne	$t2, $t1, TMerror
	bne	$t3, $t0, TMerror

	lw	$t0, 0($a0)
	lw	$t1, 4($a0)
	li	$t2, 0
TMw1:
	bge	$t2, $t0, TMend
	li	$t3, 0
TMw2:
	bge	$t3, $t1, TMw2end


	# Read Aij[
	sll	$t4, $t3, 2	# t4 = j*4
	sll	$t5, $t2, 2	# t5 = i*4
	mul	$t5, $t5, $t1	# t5 = n*i*4
	add	$t4, $t4, $t5	# t4 = n*i*4 + j*4
	addi	$t4, $t4, 8	# t4 = n*i*4 + j*4 + 8
	add	$t4, $a0, $t4	# t4 = Ma + n*i*4 + j*4 + 8
	lwc1	$f0, 0 ($t4)	# f0 = Aij

	# Store in Bji
	sll	$t6, $t2, 2	# t6 = i*4
	sll	$t7, $t3, 2	# t7 = j*4
	mul	$t7, $t7, $t1	# t7 = n*j*4
	add	$t6, $t6, $t7	# t6 = n*j*4 + i*4
	addi	$t6, $t6, 8	# t6 = n*j*4 + i*4 + 8
	add	$t6, $a1, $t6	# t6 = Mb + n*j*4 + i*4 + 8
	swc1	$f0, 0 ($t6)	# Bji = f0

	addi	$t3, $t3, 1
	j	TMw2
TMw2end:
	addi	$t2, $t2, 1
	j	TMw1
TMerror:
	print_str ("transposeMatrix: operation impossible\n")
TMend:
	lw	$ra, 4 ($sp)	# save ra
	add	$sp, $sp, 8	# destroy stack (2 bytes)
	jr	$ra


# --------------------------------------------------- #
# FUNCTION float detMatrix2 ( struct Matrix *M )
# --------------------------------------------------- #
# Brief: calculates the determinant of a 2x2 matrix
# Function prefix: DM2
# Pseudo code
  # if (m!=2 or n!= 2) print error; return 0;
  # return (AD - BC)
# Variables map
  # t0 = m (line max)
  # t1 = n (col max)
# Stack organization
  # | $a0       | 8 ($sp) (quadro anterior)
  # |===========|
  # | $ra       | 4 ($sp)
  # |-----------|
  # | $a0       | 0 ($sp) (available for the next function)
  # |-----------|
detMatrix2:
	add	$sp, $sp, -8	# create stack (2 bytes)
	sw	$ra, 4 ($sp)	# save ra

	# dimention verification
	lw	$t0, 0($a0)	# m
	lw	$t1, 4($a0)	# n
	li	$t2, 2
	bne	$t0, $t2, DM2error

	# Calculates determinant (crammer rule)
	lwc1	$f0, 8($a0)	# A
	lwc1	$f1, 12($a0)	# B
	lwc1	$f2, 16($a0)	# C
	lwc1	$f3, 20($a0)	# D

	mul.s	$f4, $f0, $f3
	mul.s	$f5, $f1, $f2
	sub.s	$f6, $f4, $f5
	mfc1	$v0, $f6
	j	DM2end

DM2error:
	print_str ("detMatrix2: operation impossible\n")
	add	$v0, $zero, $zero
DM2end:
	lw	$ra, 4 ($sp)	# save ra
	add	$sp, $sp, 8	# destroy stack (2 bytes)
	jr	$ra
