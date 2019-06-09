# --------------------------------------------------- #
# FUNCTION void bubbleSortCrescent ( int * v , int size )
# --------------------------------------------------- #
# Brief: bubble sort in an integer array, in crescent order (there is another funtion to decrescent)
# Function prefix: bubblec
# Coments: its a leaf funtion, so we dont need to save the parameters nor ra. Size its in bytes 
# Varibles map
  # a0 = array addr
  # a1 (n) = array size
  # s0 (i) = outer counter
  # s1 (j) = inner counter
# Pseudo code C
  # for (i=4; i <= n-4 ; i+=4)
  #   for(j=0; j <= n - i - 4; j+=4)
  #     if(a[j] < a[j+4]){
  #        temp=a[j+4];
  #        a[j+4]=a[j];
  #        a[j]=temp;
  #     }
# Stack organization
  # |===========|
  # | $s1       | 4 ($sp)
  # |-----------|
  # | $s0       | 0 ($sp)
  # |-----------|
bubbleSortCrescent:
	addi	$sp, $sp, -8
	sw	$s0, 0 ($sp)
	sw	$s1, 4 ($sp)

	addi	$a1, $a1, -4		# a1 = max comparation position
	addi	$s0, $zero, 4		# i = 4
bubblecFor1begin:
	bgt	$s0, $a1, bubblecFor1end # for (i=4; i <= n-4 ; i+=4)
	addi	$s1, $zero, 0
bubblecFor2begin:
	sub	$t0, $a1, $s0
	bgt	$s1, $t0, bubblecFor2end# for(j=0; j <= n - i - 4; j+=4)

	add	$t0, $s1, $a0		# t0 = [j] addr
	lw	$t1, 0($t0)		# t1 = a[j]
	lw	$t2, 4($t0)		# t2 = a[j+4]

	ble	$t1, $t2, bubblecIf1end	# if(a[j] > a[j+4]) // The only change in crescente/decrescente is here
	sw	$t1, 4 ($t0)		# a[j+4]=a[j];
	sw	$t2, 0 ($t0)		# a[j]= a[j+4] before change ;

bubblecIf1end:
	addi	$s1, $s1, 4		# j+=4
	j	bubblecFor2begin	# end of inner loop

bubblecFor2end:
	addi	$s0, $s0, 4		# i+=4
	j	bubblecFor1begin	# end of outer loop
bubblecFor1end:
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra

# --------------------------------------------------- #
# FUNCTION void bubbleSortDecrescent ( int * v , int size )
# --------------------------------------------------- #
# Brief: Buble sort in an integer array, in decrescent order (there is another funtion to crescent)
# Function prefix: bubbled
# Coments: its a leaf funtion, so we dont need to save the parameters nor ra. Size its in bytes
# Varibles map
  # a0 = array addr
  # a1 (n) = array size
  # s0 (i) = outer counter
  # s1 (j) = inner counter
# Pseudo code C
  # for (i=4; i <= n-4 ; i+=4)
  #   for(j=0; j <= n - i - 4; j+=4)
  #     if(a[j] < a[j+4]){
  #        temp=a[j+4];
  #        a[j+4]=a[j];
  #        a[j]=temp;
  #     }
# Stack organization
  # |===========|
  # | $s1       | 4 ($sp)
  # |-----------|
  # | $s0       | 0 ($sp)
  # |-----------|
bubbleSortDecrescent:
	addi	$sp, $sp, -8
	sw	$s0, 0 ($sp)
	sw	$s1, 4 ($sp)

	addi	$a1, $a1, -4		# a1 = max comparation position
	addi	$s0, $zero, 4		# i = 4
bubbledFor1begin:
	bgt	$s0, $a1, bubbledFor1end # for (i=4; i <= n-4 ; i+=4)
	addi	$s1, $zero, 0
bubbledFor2begin:
	sub	$t0, $a1, $s0
	bgt	$s1, $t0, bubbledFor2end# for(j=0; j <= n - i - 4; j+=4)

	add	$t0, $s1, $a0		# t0 = [j] addr
	lw	$t1, 0($t0)		# t1 = a[j]
	lw	$t2, 4($t0)		# t2 = a[j+4]

	bge	$t1, $t2, bubbledIf1end	# if(a[j] < a[j+4]) // The only change in crescente/decrescente is here
	sw	$t1, 4 ($t0)		# a[j+4]=a[j];
	sw	$t2, 0 ($t0)		# a[j]= a[j+4] before change ;

bubbledIf1end:
	addi	$s1, $s1, 4		# j+=4
	j	bubbledFor2begin	# end of inner loop

bubbledFor2end:
	addi	$s0, $s0, 4		# i+=4
	j	bubbledFor1begin	# end of outer loop
bubbledFor1end:
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra
