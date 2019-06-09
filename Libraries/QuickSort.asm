# --------------------------------------------------- #
# Main MOVE TO TEST
# --------------------------------------------------- #
# Brief: Just for testing poupouses.
.text 0x00400000
	addi $t0, $zero, 8
	addi $t1, $zero, 5
	addi $t2, $zero, 1
	addi $t3, $zero, 3
	addi $t4, $zero, 2
	addi $t5, $zero, 20
	addi $t6, $zero, 7
	addi $t7, $zero, 666

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
	addi	$a2, 32		# array bytes

	#jal	quickSortDecrescent	# quickSort(&vec[0], 0, size)
jal _particion
	# Finish program
	li	$v0, 17			# Service terminate
	li	$a0, 0			# Service parameter (termination result)
	syscall

# --------------------------------------------------- #
# FUNCTION void quickSortCrescent (int * v , int left, int right)
# --------------------------------------------------- #
# Brief: quick sort in an integer array, in crescent order (there is another funtion to decrescent)
# Function prefix: quickc
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
# Peseudo code C
  # int pivot = A[left];
  # int i = left - 1;
  # int j = right + 1;
  # while(1){
  #     do i++; while (A[i] < pivot);
  #     do j--; while (A[j] > pivot);
  #     if (i>=j)
  #         return j;
  #     _swap (&A[i], &A[j]);
  # }
	# Variables map
	  # s0 = pivot
	  # s1 = i (left couter)
	  # s2 = j (right counter)
	_particion:
