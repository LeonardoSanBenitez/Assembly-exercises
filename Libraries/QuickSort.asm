# --------------------------------------------------- #
# Main MOVE TO TEST
# --------------------------------------------------- #
# Brief: Just for testing poupouses.
# Stack organization
  # |-----------|
  # | $a2       | 8 ($sp) (available for the next function)
  # |-----------|
  # | $a1       | 4 ($sp) (available for the next function)
  # |-----------|
  # | $a0       | 0 ($sp) (available for the next function)
  # |-----------|
  
.text 0x00400000
	addi $t0, $zero, 8
	addi $t1, $zero, 5
	addi $t2, $zero, 9
	addi $t3, $zero, 3
	addi $t4, $zero, 2
	addi $t5, $zero, 20
	addi $t6, $zero, 7
	addi $t7, $zero, 2

	sw $t0, 0 ($gp)
	sw $t1, 4 ($gp)
	sw $t2, 8 ($gp)
	sw $t3, 12 ($gp)
	sw $t4, 16 ($gp)
	sw $t5, 20 ($gp)
	sw $t6, 24 ($gp)
	sw $t7, 28 ($gp)

	add	$a0, $zero, $gp
	li	$a1, 0
	li	$a2, 28		# n*-4 (final index, in bytes)

	jal _particion
	#jal	quickSortDecrescent	# quickSort(&vec[0], 0, size)

	# Finish program
	li	$v0, 17			# Service terminate
	li	$a0, 0			# Service parameter (termination result)
	syscall

# --------------------------------------------------- #
# FUNCTION void quickSortCrescent (int * v , int left, int right)
# --------------------------------------------------- #
# Brief: quick sort in an integer array, in crescent order (there is another funtion to decrescent)
# Function prefix: quickc
# Parameters
  # a0 = array initial address
  # left = begining index
  # right = final index
# Peseudo code C
  # if (left < right){
  #     p = _particion(A, left, right);
  #     quickSort (A, left, p);
  #     quickSort (A, p+1, right);
  # }
quickSortDecrescent:
	jr		$ra


# --------------------------------------------------- #
# FUNCTION int _particion (int* A, int left, int right)
# --------------------------------------------------- #
# Funtion prefix: par
# Peseudo code
  # int pivot = A[left];
  # int i = left - 1;
  # int j = right + 1;
  # while(1)
  #     do i++; while (A[i] < pivot);
  #     do j--; while (A[j] > pivot);
  #     if (i>=j)
  #         return j;
  #     _swap (&A[i], &A[j]);
# Variables map
  # s0 = pivot
  # s1 = i (left couter)
  # s2 = j (right counter)
# Stack organization
  # |-----------|
  # | $a2       | 29 ($sp) (previous frame)
  # |-----------|
  # | $a1       | 28 ($sp) (previous frame)
  # |-----------|
  # | $a0       | 24 ($sp) (previous frame)
  # |===========|
  # | $ra       | 20 ($sp)
  # |-----------|
  # | $s2       | 16 ($sp)
  # |-----------|
  # | $s1       | 12 ($sp)
  # |-----------|
  # | $s0       | 8 ($sp)
  # |-----------|
  # | $a1       | 4 ($sp) (available for the next function)
  # |-----------|
  # | $a0       | 0 ($sp) (available for the next function)
  # |-----------|
_particion:
	addi	$sp, $sp, -24
	sw	$s0, 8 ($sp)
	sw	$s1, 12 ($sp)
	sw	$s2, 16 ($sp)
	sw	$ra, 20 ($sp)
	
	add	$t0, $a0, $a1
	lw	$s0, 0($t0)
	addi	$s1, $a1, -4
	addi	$s2, $a2, 4
parWhile1:
	addi	$s1, $s1, 4
	add	$t0, $a0, $s1
	lw	$t1, 0 ($t0)		# t1 = A[i]
	blt	$t1, $s0, parWhile1	# while (A[i] < pivot)
parWhile2:
	addi	$s2, $s2, -4
	add	$t0, $a0, $s2
	lw	$t1, 0 ($t0)		# t1 = A[j]
	bgt	$t1, $s0, parWhile2	# while (A[j] > pivot)

	bge	$s1, $s2, parEnd	# if (i>=j) return j;
		
	sw	$a0, 24 ($sp)		# store a0 in the previus frame. a1 and a2 arent used anymore
	add	$a1, $a0, $s2		# a1 = &A[j]
	add	$a0, $a0, $s1		# a0 = &A[i]
	jal	_swap			# _swap (&A[i], &A[j])
	lw	$a0, 24 ($sp)		# restore a0
	j	parWhile1	
parEnd:
	lw	$s0, 8 ($sp)
	lw	$s1, 12 ($sp)
	lw	$s2, 16 ($sp)
	lw	$ra, 20 ($sp)
	addi	$sp, $sp, 24

	add	$v0, $s2, $zero
	jr	$ra			# return j
	
# --------------------------------------------------- #
# FUNCTION void _swap (int* A[i], int* A[j])
# --------------------------------------------------- #
_swap: 
	lw	$t0, 0($a0)
	lw	$t1, 0($a1)
	sw	$t1, 0($a0)
	sw	$t0, 0($a1)
	jr	$ra