# --------------------------------------- #
#  Libraries
# --------------------------------------- #
.text 0x00500000
.include "../Libraries/SyscallsFunctions.asm"
.include "../Libraries/macros.asm"
.include "../Libraries/BubbleSort.asm"

# --------------------------------------------------- #
# Main data section
# --------------------------------------------------- #
.data
arraySize:	.space 4
array:		.space 1024
# Jump Table
menuJT:	.word	menu0, menu1, menu2, menu3, menu4, menu5, menu6
menu:	.asciiz "\n----------------------------------------\n0) Inicialização aleatória \n1) Imprimir \n2) Imprimir crescente \n3) Imprimir decrescente \n4) Somatório do array \n5) Média do array \n6) Finish program \n----------------------------------------\n"
menu0S: .asciiz "Size of array (max 256): "
menu1S: .asciiz "Array content: "
menu2S: .asciiz "Ordered array content (crescent): "
menu3S: .asciiz "Ordered array content (decrescent): "
menu4S: .asciiz "Array sum: "
menu5S: .asciiz "Array mean: "
menu6S: .asciiz "Bye bye :)"
menuDefS: .asciiz "Sorry, invalid option"


# --------------------------------------------------- #
# Main
# --------------------------------------------------- #
.text 0x00400000
main:
	jal	printMenu
	beq	$v0, $zero, main
	 # Finish program
	li	$v0, 17			# Service terminate
	li	$a0, 0			# Service parameter (termination result)
	syscall

# --------------------------------------------------- #
# FUNCTION void menu ()
# --------------------------------------------------- #
# Brief: Print the options for array manipulation
# Function prefix: menu
# Stack organization
  # |===========|
  # | $ra       | 12 ($sp)
  # |-----------|
  # | $a2       | 8 ($sp) (available for the next function)
  # |-----------|
  # | $a1       | 4 ($sp) (available for the next function)
  # |-----------|
  # | $a0       | 0 ($sp) (available for the next function)
  # |-----------|
printMenu:
	addi	$sp, $sp, -16
	sw	$ra, 12($sp)

	# Print menu
	la	$a0, menu		# Service parameter (address of string)
	jal	printString

	# Read user awnser
	li	$v0, 5			# Service read integer (return in v0)
	jal	getInt


	## Swicth (v0){case 1: ...}
	#check bounds
	blt $v0, $zero menuDef	# if read<0, default
	addi $t0, $zero, 6
	bgt $v0, $t0, menuDef	# if read>6, default

	#translate case
	la $t0, menuJT		# Jump table base addr
	mul $t1, $v0, 4		# convert s0 to bytes
	add $t0, $t0, $t1	# t0 = &JumTable[cause]
	lw $t2, 0 ($t0)		# load label
	jr $t2
# Array init
menu0:
	# Print string
	li	$v0, 4			# Service print string
	la	$a0, menu0S		# Service parameter (address of string)
	syscall
	jal	getInt

	la	$a0, array	# pointer parameter
	move	$a1, $v0	# size parameter
	sw	$v0, arraySize	# store size in "structure"
	jal	ArrayInitRand

	li	$v0, 0			# printMenu return value (0 = keep running)
	j	menuEnd
# Array print
menu1:
	# Print string
	la	$a0, menu1S		# Service parameter (address of string)
	jal	printString

	# print array
	la	$a0, array
	lw	$a1, arraySize
	jal	arrayPrint

	li	$v0, 0			# printMenu return value (0 = keep running)
	j	menuEnd
# Print crescent
menu2:
	la	$a0, array
	lw	$a1, arraySize
	sll	$a1, $a1, 2
	jal	bubbleSortCrescent

	# Print string
	la	$a0, menu1S		# Service parameter (address of string)
	jal	printString

	# print array
	la	$a0, array
	lw	$a1, arraySize
	jal	arrayPrint

	li	$v0, 0			# printMenu return value (0 = keep running)
	j	menuEnd
# Print Decrescent
menu3:
	la	$a0, array
	lw	$a1, arraySize
	sll	$a1, $a1, 2
	jal	bubbleSortDecrescent

	# Print string
	la	$a0, menu1S		# Service parameter (address of string)
	jal	printString

	# print array
	la	$a0, array
	lw	$a1, arraySize
	jal	arrayPrint

	li	$v0, 0			# printMenu return value (0 = keep running)
	j	menuEnd
# Sum
menu4:
	la	$a0, array
	lw	$a1, arraySize
	jal	arraySum
	add	$t3, $v0, $zero		#result in t3

	# Print result
	la	$a0, menu4S		# Service parameter (address of string)
	jal	printString
	add	$a0, $t3, $zero
	jal	printInt

	li	$v0, 0			# printMenu return value (0 = keep running)
	j	menuEnd
# Mean
menu5:
	la	$a0, array
	lw	$a1, arraySize
	jal	arrayMean
	add	$t3, $v0, $zero		#result in t3 (double)
	add	$t4, $v1, $zero

	# Print result
	la	$a0, menu5S		# Service parameter (address of string)
	jal	printString
	add	$a0, $t3, $zero
	add	$a1, $t4, $zero
	jal	printDouble

	li	$v0, 0			# printMenu return value (0 = keep running)
	j	menuEnd
# Finish
menu6:
	# Print string
	li	$v0, 4			# Service print string
	la	$a0, menu6S		# Service parameter (address of string)
	syscall

	li	$v0, 1			# printMenu return value (1 = get out of loop)
	j	menuEnd
menuDef:
	# Print string
	li	$v0, 4			# Service print string
	la	$a0, menuDefS		# Service parameter (address of string)
	syscall
menuEnd:
	lw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jr	$ra

# --------------------------------------------------- #
# FUNCTION ArrayInitRand (*array, size)
# --------------------------------------------------- #
# Funcion prefix: AIR
ArrayInitRand:
	add	$t0, $a0, $zero	# pointer
	sll	$a1, $a1, 2	# max
	add	$t1, $a0, $a1	# max addr


	# iterate through array
AIRloop:
	bge	$t0, $t1, AIRend
	# atribute random values
	li	$v0, 42	# return a random value in $a0, with a1 upper bound
	syscall
	#li	$a0, 666
	sw	$a0, 0($t0)
	li	$a1, 99
	addi	$t0, $t0, 4
	j	AIRloop

AIRend:
	jr	$ra

# --------------------------------------------------- #
# FUNCTION void arrayPrint (*array, size)
# --------------------------------------------------- #
# Function prefix: AR
# Stack organization
  # |===========|
  # | $ra       | 4 ($sp)
  # |-----------|
  # | $a0       | 0 ($sp) (available for the next function)
  # |-----------|
arrayPrint:
	addi	$sp, $sp, -8
	sw	$ra, 4($sp)

	add	$t0, $a0, $zero	# pointer
	sll	$a1, $a1, 2	# max
	add	$t1, $a0, $a1	# max addr

	# iterate through array
ARloop:
	bge	$t0, $t1, ARend
	# read and print
	lw	$a0, 0($t0)
	jal	printInt
	print_str(" ")
	addi	$t0, $t0, 4
	j	ARloop

ARend:
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra


# --------------------------------------------------- #
# FUNCTION float arraySum (*array, size)
# --------------------------------------------------- #
# Function prefix: AS
arraySum:
	sll	$t0, $a1, 2		# t0 = size in bytes
	add	$t1, $a0, $t0	# t1 = max array addr
	li	$v0, 0		# init accumulator
ASloop:	bge	$a0, $t1, ASend	# while (ptr < ptrMax)
	lw	$t2, 0 ($a0)		# t2 = element
	add	$v0, $v0, $t2	# v0 = acumulator
	addi	$a0, $a0, 4	# ptr++
	j	ASloop
ASend:
	jr	$ra

# --------------------------------------------------- #
# FUNCTION float arrayMean (*array, size)
# --------------------------------------------------- #
# Function prefix: AM
arrayMean:
	sll	$t0, $a1, 2		# t0 = size in bytes
	add	$t1, $a0, $t0	# t1 = max array addr
	li	$v0, 0		# init accumulator
AMloop:	bge	$a0, $t1, AMend	# while (ptr < ptrMax)
	lw	$t2, 0 ($a0)		# t2 = element
	add	$v0, $v0, $t2	# v0 = acumulator
	addi	$a0, $a0, 4	# ptr++
	j 	AMloop
AMend:
	# calculate mean (double)
	mtc1	$v0, $f2
	mtc1	$a1, $f4
	div.d	$f0, $f2, $f4
	mfc1.d	$v0, $f0
	jr	$ra
